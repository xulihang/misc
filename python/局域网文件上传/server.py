# file_upload_server.py
import os
import uuid
from datetime import datetime
from flask import Flask, request, render_template_string, jsonify

app = Flask(__name__)

# 配置文件保存目录
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mp3', 'zip', 'rar'}

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 500 * 1024 * 1024  # 500MB 最大上传限制

def allowed_file(filename):
    """检查文件扩展名是否允许"""
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# HTML模板
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>文件上传服务器</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        .upload-area {
            border: 2px dashed #667eea;
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .upload-area:hover {
            background: #f0f0ff;
            border-color: #764ba2;
        }
        input[type="file"] {
            display: none;
        }
        .file-list {
            margin-top: 20px;
        }
        .file-item {
            background: #f5f5f5;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .file-name {
            flex: 1;
            word-break: break-all;
        }
        .progress-bar {
            width: 100%;
            height: 5px;
            background: #e0e0e0;
            border-radius: 5px;
            overflow: hidden;
            margin-top: 5px;
        }
        .progress {
            width: 0%;
            height: 100%;
            background: #4caf50;
            transition: width 0.3s;
        }
        button {
            background: #667eea;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background: #764ba2;
        }
        .status {
            margin-top: 20px;
            padding: 10px;
            border-radius: 5px;
            display: none;
        }
        .success {
            background: #d4edda;
            color: #155724;
            display: block;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            display: block;
        }
        .info {
            background: #d1ecf1;
            color: #0c5460;
            margin-bottom: 10px;
        }
        .upload-btn {
            background: #4caf50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
            font-size: 16px;
        }
        .upload-btn:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📁 文件上传服务器</h1>
        <div id="info" class="status info">✨ 准备就绪，选择文件后点击上传</div>
        <div class="upload-area" onclick="document.getElementById('fileInput').click()">
            <p>📂 点击选择文件</p>
            <input type="file" id="fileInput" multiple>
        </div>
        <div id="fileList" class="file-list"></div>
        <button class="upload-btn" onclick="uploadFiles()">⬆️ 上传所有文件</button>
    </div>

    <script>
        let selectedFiles = [];

        document.getElementById('fileInput').addEventListener('change', function(e) {
            selectedFiles = Array.from(e.target.files);
            displayFileList();
        });

        function displayFileList() {
            const container = document.getElementById('fileList');
            container.innerHTML = '';
            selectedFiles.forEach((file, index) => {
                const fileDiv = document.createElement('div');
                fileDiv.className = 'file-item';
                fileDiv.innerHTML = `
                    <div class="file-name">
                        ${file.name} (${(file.size / 1024).toFixed(2)} KB)
                        <div class="progress-bar">
                            <div class="progress" id="progress-${index}"></div>
                        </div>
                    </div>
                    <button onclick="removeFile(${index})">删除</button>
                `;
                container.appendChild(fileDiv);
            });
        }

        function removeFile(index) {
            selectedFiles.splice(index, 1);
            displayFileList();
            if (selectedFiles.length === 0) {
                document.getElementById('fileInput').value = '';
            }
        }

        function showStatus(message, type) {
            const statusDiv = document.getElementById('status') || createStatusDiv();
            statusDiv.textContent = message;
            statusDiv.className = `status ${type}`;
            setTimeout(() => {
                statusDiv.style.display = 'none';
            }, 3000);
        }

        function createStatusDiv() {
            const div = document.createElement('div');
            div.id = 'status';
            const container = document.querySelector('.container');
            container.insertBefore(div, document.getElementById('info').nextSibling);
            return div;
        }

        async function uploadFiles() {
            if (selectedFiles.length === 0) {
                showStatus('请先选择文件', 'error');
                return;
            }

            for (let i = 0; i < selectedFiles.length; i++) {
                const file = selectedFiles[i];
                const formData = new FormData();
                formData.append('file', file);

                try {
                    const xhr = new XMLHttpRequest();
                    xhr.open('POST', '/upload', true);
                    
                    xhr.upload.addEventListener('progress', (e) => {
                        if (e.lengthComputable) {
                            const percentComplete = (e.loaded / e.total) * 100;
                            const progressBar = document.getElementById(`progress-${i}`);
                            if (progressBar) {
                                progressBar.style.width = percentComplete + '%';
                            }
                        }
                    });

                    await new Promise((resolve, reject) => {
                        xhr.onload = () => {
                            if (xhr.status === 200) {
                                resolve();
                            } else {
                                reject();
                            }
                        };
                        xhr.onerror = () => reject();
                        xhr.send(formData);
                    });

                    showStatus(`${file.name} 上传成功！`, 'success');
                } catch (error) {
                    showStatus(`${file.name} 上传失败`, 'error');
                }
            }
            
            // 清空已上传的文件
            selectedFiles = [];
            document.getElementById('fileInput').value = '';
            displayFileList();
        }
    </script>
</body>
</html>
'''

@app.route('/')
def index():
    """显示上传页面"""
    return render_template_string(HTML_TEMPLATE)

@app.route('/upload', methods=['POST'])
def upload_file():
    """处理文件上传"""
    try:
        if 'file' not in request.files:
            return jsonify({'error': '没有文件'}), 400
        
        file = request.files['file']
        
        if file.filename == '':
            return jsonify({'error': '文件名为空'}), 400
        
        if not allowed_file(file.filename):
            return jsonify({'error': '文件类型不允许'}), 400
        
        # 生成唯一文件名避免冲突
        original_filename = file.filename
        ext = original_filename.rsplit('.', 1)[1].lower() if '.' in original_filename else ''
        new_filename = f"{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}.{ext}" if ext else f"{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}"
        
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], new_filename)
        file.save(filepath)
        
        return jsonify({
            'success': True,
            'filename': original_filename,
            'saved_as': new_filename,
            'size': os.path.getsize(filepath)
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/files')
def list_files():
    """列出已上传的文件"""
    files = []
    for filename in os.listdir(UPLOAD_FOLDER):
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        if os.path.isfile(filepath):
            files.append({
                'name': filename,
                'size': os.path.getsize(filepath),
                'modified': datetime.fromtimestamp(os.path.getmtime(filepath)).strftime('%Y-%m-%d %H:%M:%S')
            })
    return jsonify(files)

if __name__ == '__main__':
    # 获取本机局域网IP
    import socket
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    
    print("=" * 50)
    print("🚀 文件上传服务器已启动！")
    print("=" * 50)
    print(f"📱 请在手机浏览器访问: http://{local_ip}:5000")
    print("=" * 50)
    print("按 Ctrl+C 停止服务器")
    print("=" * 50)
    
    # 启动服务器，host='0.0.0.0' 允许局域网访问
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)