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

# 使用新的链接下载 Chrome 浏览器并安装
RUN wget http://wi6.cn/chrome-linux64.zip -O chrome.zip && \
    unzip chrome.zip && \
    mv chrome-linux64 /opt/google/chrome && \
    rm chrome.zip

# 使用新的链接下载 ChromeDriver 并安装
RUN wget http://wi6.cn/chromedriver-linux64.zip -O chromedriver.zip && \
    unzip chromedriver.zip && \
    mv chromedriver /usr/local/bin/chromedriver && \
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
