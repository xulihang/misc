#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
腾讯企业邮箱邮件导出工具
支持批量导出邮件为EML格式，支持增量备份
"""

import imaplib
import email
from email.header import decode_header
from email.utils import parsedate_to_datetime
import os
import sys
import getpass
from datetime import datetime, timedelta
import argparse
import time
import hashlib
import json
from pathlib import Path

class TencentEmailExporter:
    """腾讯企业邮箱导出器"""
    
    def __init__(self, email_address, password, imap_server='imap.exmail.qq.com', port=993):
        """
        初始化邮件导出器
        
        Args:
            email_address: 邮箱地址
            password: 密码（可能是密码或授权码）
            imap_server: IMAP服务器地址
            port: IMAP端口
        """
        self.email = email_address
        self.password = password
        self.imap_server = imap_server
        self.port = port
        self.connection = None
        self.progress_callback = None
        
    def connect(self):
        """连接到邮箱服务器"""
        try:
            print(f"正在连接到 {self.imap_server}:{self.port}...")
            self.connection = imaplib.IMAP4_SSL(self.imap_server, self.port)
            self.connection.login(self.email, self.password)
            print("✓ 登录成功")
            return True
        except Exception as e:
            print(f"✗ 连接失败: {e}")
            return False
    
    def list_folders(self):
        """列出所有文件夹"""
        if not self.connection:
            return []
        
        status, folders = self.connection.list()
        if status != 'OK':
            return []
        
        folder_names = []
        for folder in folders:
            # 解析文件夹名称
            folder_name = folder.decode().split('"/"')[-1].strip()
            if folder_name:
                folder_names.append(folder_name)
        
        return folder_names
    
    def select_folder(self, folder='INBOX'):
        """选择文件夹"""
        if not self.connection:
            return False
        
        status, message_count = self.connection.select(folder, readonly=True)
        if status != 'OK':
            print(f"无法访问文件夹: {folder}")
            return False
        
        message_count = int(message_count[0])
        print(f"✓ 已选择文件夹 '{folder}'，共 {message_count} 封邮件")
        return message_count
    
    def decode_header_value(self, header_value):
        """解码邮件头信息"""
        if header_value is None:
            return ""
        
        decoded_parts = decode_header(header_value)
        decoded_strings = []
        
        for part, charset in decoded_parts:
            if isinstance(part, bytes):
                try:
                    if charset:
                        decoded_strings.append(part.decode(charset))
                    else:
                        decoded_strings.append(part.decode('utf-8', errors='ignore'))
                except:
                    decoded_strings.append(part.decode('utf-8', errors='ignore'))
            else:
                decoded_strings.append(str(part))
        
        return ' '.join(decoded_strings)
    
    def get_safe_filename(self, subject, date, max_length=200):
        """生成安全的文件名"""
        # 清理文件名中的非法字符
        invalid_chars = '<>:"/\\|?*'
        for char in invalid_chars:
            subject = subject.replace(char, '_')
        
        # 格式化日期
        date_str = date.strftime('%Y%m%d_%H%M%S') if date else datetime.now().strftime('%Y%m%d_%H%M%S')
        
        # 组合文件名
        filename = f"{date_str}_{subject}"
        
        # 限制长度
        if len(filename) > max_length:
            filename = filename[:max_length]
        
        return filename + '.eml'
    
    def extract_email_body(self, email_message):
        """提取邮件正文（用于进度显示）"""
        body = ""
        if email_message.is_multipart():
            for part in email_message.walk():
                content_type = part.get_content_type()
                if content_type == "text/plain":
                    try:
                        payload = part.get_payload(decode=True)
                        charset = part.get_content_charset() or 'utf-8'
                        body = payload.decode(charset, errors='ignore')[:100]
                        break
                    except:
                        pass
        else:
            try:
                payload = email_message.get_payload(decode=True)
                charset = email_message.get_content_charset() or 'utf-8'
                body = payload.decode(charset, errors='ignore')[:100]
            except:
                pass
        
        return body.strip()
    
    def export_emails(self, output_dir='exported_emails', 
                      start_date=None, end_date=None, 
                      max_emails=None, folder='INBOX',
                      incremental=True, progress_callback=None):
        """
        导出邮件
        
        Args:
            output_dir: 输出目录
            start_date: 开始日期
            end_date: 结束日期
            max_emails: 最大导出数量
            folder: 文件夹名称
            incremental: 是否增量导出（跳过已存在的邮件）
            progress_callback: 进度回调函数
        """
        self.progress_callback = progress_callback
        
        # 创建输出目录
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        # 创建元数据文件路径
        metadata_file = output_path / '.export_metadata.json'
        
        # 加载已导出的邮件ID（用于增量导出）
        exported_ids = set()
        if incremental and metadata_file.exists():
            try:
                with open(metadata_file, 'r', encoding='utf-8') as f:
                    metadata = json.load(f)
                    exported_ids = set(metadata.get('exported_ids', []))
                print(f"✓ 加载增量备份记录，已导出 {len(exported_ids)} 封邮件")
            except:
                pass
        
        # 选择文件夹
        message_count = self.select_folder(folder)
        if not message_count:
            return 0
        
        # 获取所有邮件的ID
        status, message_ids = self.connection.search(None, 'ALL')
        if status != 'OK':
            print("无法获取邮件列表")
            return 0
        
        message_list = message_ids[0].split()
        total_emails = len(message_list)
        print(f"总邮件数: {total_emails}")
        
        # 过滤已导出的邮件
        if incremental:
            new_messages = [mid for mid in message_list if mid.decode() not in exported_ids]
            print(f"新邮件数: {len(new_messages)}")
            if not new_messages:
                print("没有新邮件需要导出")
                return 0
            message_list = new_messages
        
        # 应用限制
        if max_emails and max_emails < len(message_list):
            message_list = message_list[:max_emails]
            print(f"限制导出数量: {len(message_list)}")
        
        # 处理邮件
        exported_count = 0
        skipped_count = 0
        failed_count = 0
        
        for idx, msg_id in enumerate(message_list, 1):
            try:
                # 获取邮件
                status, msg_data = self.connection.fetch(msg_id, '(RFC822)')
                if status != 'OK':
                    print(f"✗ 无法获取邮件 {msg_id}")
                    failed_count += 1
                    continue
                
                # 解析邮件
                raw_email = msg_data[0][1]
                email_message = email.message_from_bytes(raw_email)
                
                # 提取邮件信息
                subject = self.decode_header_value(email_message.get('Subject', '无主题'))
                date_str = email_message.get('Date', '')
                
                # 解析日期
                try:
                    date = parsedate_to_datetime(date_str) if date_str else datetime.now()
                except:
                    date = datetime.now()
                
                # 检查日期范围
                if start_date and date < start_date:
                    skipped_count += 1
                    continue
                if end_date and date > end_date:
                    skipped_count += 1
                    continue
                
                # 生成文件名
                filename = self.get_safe_filename(subject, date)
                filepath = output_path / filename
                
                # 处理重名文件
                if filepath.exists():
                    base_name = filepath.stem
                    counter = 1
                    while filepath.exists():
                        filepath = output_path / f"{base_name}_{counter}.eml"
                        counter += 1
                
                # 保存邮件
                with open(filepath, 'wb') as f:
                    f.write(raw_email)
                
                exported_count += 1
                exported_ids.add(msg_id.decode())
                
                # 显示进度
                body_preview = self.extract_email_body(email_message)
                progress_msg = f"[{idx}/{len(message_list)}] 导出: {filename[:60]}"
                if body_preview:
                    progress_msg += f" - {body_preview[:50]}..."
                
                print(progress_msg)
                
                if self.progress_callback:
                    self.progress_callback(idx, len(message_list), filename)
                
            except Exception as e:
                print(f"✗ 导出失败 {msg_id}: {e}")
                failed_count += 1
        
        # 保存元数据
        metadata = {
            'exported_ids': list(exported_ids),
            'last_export': datetime.now().isoformat(),
            'total_exported': len(exported_ids),
            'last_export_count': exported_count
        }
        
        with open(metadata_file, 'w', encoding='utf-8') as f:
            json.dump(metadata, f, ensure_ascii=False, indent=2)
        
        # 输出统计
        print("\n" + "="*50)
        print("导出完成统计:")
        print(f"✓ 成功导出: {exported_count} 封邮件")
        print(f"⊘ 跳过: {skipped_count} 封邮件")
        print(f"✗ 失败: {failed_count} 封邮件")
        print(f"📁 保存位置: {output_path.absolute()}")
        print("="*50)
        
        return exported_count
    
    def disconnect(self):
        """断开连接"""
        if self.connection:
            try:
                self.connection.close()
                self.connection.logout()
            except:
                pass
            print("✓ 已断开连接")

def interactive_mode():
    """交互式模式"""
    print("="*60)
    print("腾讯企业邮箱邮件导出工具")
    print("="*60)
    
    # 获取登录信息
    email = input("请输入邮箱地址: ").strip()
    password = getpass.getpass("请输入密码/授权码: ").strip()
    
    if not email or not password:
        print("邮箱和密码不能为空")
        return
    
    # 创建导出器
    exporter = TencentEmailExporter(email, password)
    
    # 连接
    if not exporter.connect():
        return
    
    try:
        # 显示文件夹列表
        print("\n可用的文件夹:")
        folders = exporter.list_folders()
        for i, folder in enumerate(folders, 1):
            print(f"  {i}. {folder}")
        
        # 选择文件夹
        folder_choice = input("\n请输入文件夹编号或名称 (默认: INBOX): ").strip()
        if folder_choice.isdigit():
            idx = int(folder_choice) - 1
            if 0 <= idx < len(folders):
                folder = folders[idx]
            else:
                folder = 'INBOX'
        elif folder_choice:
            folder = folder_choice
        else:
            folder = 'INBOX'
        
        # 设置导出选项
        print("\n导出选项:")
        print("1. 导出全部邮件")
        print("2. 导出最近N天的邮件")
        print("3. 导出指定数量邮件")
        
        choice = input("请选择 (1/2/3，默认1): ").strip()
        
        max_emails = None
        start_date = None
        
        if choice == '2':
            days = input("请输入天数 (默认30): ").strip()
            days = int(days) if days.isdigit() else 30
            start_date = datetime.now() - timedelta(days=days)
            print(f"将导出最近 {days} 天的邮件")
        elif choice == '3':
            count = input("请输入导出数量: ").strip()
            max_emails = int(count) if count.isdigit() else None
        
        # 设置输出目录
        output_dir = input("请输入导出目录 (默认: exported_emails): ").strip()
        if not output_dir:
            output_dir = 'exported_emails'
        
        # 是否增量导出
        incremental = input("是否启用增量导出（跳过已导出邮件）? (y/n, 默认y): ").strip().lower()
        incremental = incremental != 'n'
        
        # 开始导出
        print("\n开始导出邮件...")
        exported = exporter.export_emails(
            output_dir=output_dir,
            start_date=start_date,
            max_emails=max_emails,
            folder=folder,
            incremental=incremental
        )
        
        if exported > 0:
            print(f"\n✓ 成功导出 {exported} 封邮件")
            
    except KeyboardInterrupt:
        print("\n\n用户中断操作")
    except Exception as e:
        print(f"\n✗ 发生错误: {e}")
    finally:
        exporter.disconnect()

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='腾讯企业邮箱邮件导出工具')
    parser.add_argument('-e', '--email', help='邮箱地址')
    parser.add_argument('-p', '--password', help='密码或授权码')
    parser.add_argument('-o', '--output', default='exported_emails', help='输出目录')
    parser.add_argument('-f', '--folder', default='INBOX', help='邮件文件夹')
    parser.add_argument('-d', '--days', type=int, help='导出最近N天的邮件')
    parser.add_argument('-m', '--max', type=int, help='最大导出数量')
    parser.add_argument('--no-incremental', action='store_true', help='禁用增量导出')
    parser.add_argument('-i', '--interactive', action='store_true', help='交互式模式')
    
    args = parser.parse_args()
    
    # 交互式模式
    if args.interactive or not args.email:
        interactive_mode()
        return
    
    # 命令行模式
    if not args.password:
        args.password = getpass.getpass("请输入密码/授权码: ")
    
    # 创建导出器
    exporter = TencentEmailExporter(args.email, args.password)
    
    # 连接
    if not exporter.connect():
        sys.exit(1)
    
    try:
        # 计算开始日期
        start_date = None
        if args.days:
            start_date = datetime.now() - timedelta(days=args.days)
            print(f"导出最近 {args.days} 天的邮件")
        
        # 导出邮件
        exporter.export_emails(
            output_dir=args.output,
            start_date=start_date,
            max_emails=args.max,
            folder=args.folder,
            incremental=not args.no_incremental
        )
        
    except KeyboardInterrupt:
        print("\n\n用户中断操作")
    except Exception as e:
        print(f"\n✗ 发生错误: {e}")
    finally:
        exporter.disconnect()

if __name__ == "__main__":
    main()