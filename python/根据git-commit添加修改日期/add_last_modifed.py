#!/usr/bin/env python3
import os
import subprocess
from datetime import datetime
import re
import sys
import datetime
from zoneinfo import ZoneInfo

def get_git_last_modified_date(file_path):
    """获取文件在git中2025年4月前的最新提交时间（非rename改动）"""
    try:
        # 设置截止日期为2025年4月1日
        cutoff_date = datetime.datetime(2025, 4, 1, tzinfo=ZoneInfo('Asia/Shanghai'))
        cutoff_timestamp = int(cutoff_date.timestamp())
        
        # 获取所有在2025年4月前的提交，排除rename改动，按时间倒序排列
        cmd = ['git', 'log', 
               '--follow',
               '--format=%at', 
               '--', 
               file_path]
        output = subprocess.check_output(cmd).decode('utf-8').strip()
        timestamps = output.split('\n')
        
        # 过滤空字符串并转换为整数
        timestamps = [int(ts) for ts in timestamps if ts]
        
        if not timestamps:
            return None
            
        # 获取最新的时间戳（最后一个为最新）
        timestamps.reverse()
        latest_timestamp = timestamps.pop()
        while latest_timestamp > cutoff_timestamp:
            if len(timestamps) > 0:
                latest_timestamp = timestamps.pop()
            else:
                return None
        
        tz = ZoneInfo('Asia/Shanghai')
        dt_object = datetime.datetime.fromtimestamp(latest_timestamp, tz)
        
        formatted_time = dt_object.strftime('%Y-%m-%d %H:%M:%S %z')
        return formatted_time
    except subprocess.CalledProcessError:
        return None

def update_markdown_date(file_path, date):
    """更新或添加日期到markdown的YAML头"""
    with open(file_path, 'r+', encoding='utf-8') as f:
        content = f.read()
        
        # 匹配现有的YAML front matter
        yaml_pattern = re.compile(r'^---\s*\n(.*?\n)---\s*\n', re.DOTALL)
        match = yaml_pattern.match(content)
        
        date_field = f'last_modified: {date}\n'
        
        if match:
            # 已有YAML头
            yaml_content = match.group(1)
            # 检查是否已有date字段
            if re.search(r'^last_modified:\s*.*$', yaml_content, re.MULTILINE):
                # 更新现有date字段
                new_yaml = re.sub(r'^last_modified:\s*.*$', date_field, yaml_content, flags=re.MULTILINE)
            else:
                # 添加date字段到YAML头
                new_yaml = yaml_content + date_field
            new_content = content.replace(match.group(1), new_yaml, 1)
        else:
            # 没有YAML头，创建新的
            new_content = f'---\n{date_field}---\n\n{content}'
        
        # 写回文件
        f.seek(0)
        f.write(new_content)
        f.truncate()

def process_markdown_files(directory):
    """处理目录中的所有markdown文件"""
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.md'):
                file_path = os.path.join(root, file)
                date = get_git_last_modified_date(file_path)
                if date:
                    print(f'Processing {file_path} with date {date}')
                    update_markdown_date(file_path, date)
                else:
                    print(f'Skipping {file_path} - no git commit date found before April 2025')

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0]} <directory>')
        sys.exit(1)
    
    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print(f'Error: {directory} is not a valid directory')
        sys.exit(1)
    
    process_markdown_files(directory)