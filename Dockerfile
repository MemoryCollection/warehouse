# 使用 Python 3.13 作为基础镜像
FROM python:3.13-slim

# 设置工作目录
WORKDIR /app

# 复制本地代码到容器内
COPY . /app

# 设置环境变量，避免 pip 安装时进行交互
ENV PYTHONUNBUFFERED=1

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 创建目录
RUN mkdir -p /opt/google/chrome /usr/local/bin

# 下载并解压 Chrome 浏览器
RUN wget https://storage.googleapis.com/chrome-for-testing-public/133.0.6836.0/linux64/chrome-linux64.zip -O chrome.zip && \
    ls -lh chrome.zip && \
    unzip chrome.zip -d /opt/google/chrome && \
    ls -lh /opt/google/chrome && \
    rm chrome.zip

# 下载并解压 ChromeDriver
RUN wget https://storage.googleapis.com/chrome-for-testing-public/133.0.6836.0/linux64/chromedriver-linux64.zip -O chromedriver.zip && \
    ls -lh chromedriver.zip && \
    unzip chromedriver.zip -d /usr/local/bin && \
    ls -lh /usr/local/bin && \
    # 确认解压后的文件是否存在
    ls -lh /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver.zip

# 设置 Chrome 和 ChromeDriver 路径
ENV CHROME_BIN=/opt/google/chrome/chrome
ENV CHROMEDRIVER=/usr/local/bin/chromedriver

# 使用清华大学镜像源安装 pip 包
RUN pip install --no-cache-dir --timeout=600 -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip

# 安装 Python 包
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple requests beautifulsoup4 selenium PyGithub

# 设置容器启动时保持运行
CMD ["tail", "-f", "/dev/null"]
