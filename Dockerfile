# 使用 selenium/standalone-chrome 镜像作为基础镜像
FROM selenium/standalone-chrome:latest

# 设置工作目录
WORKDIR /aap

# 更新包管理器并安装 Python 和 pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && apt-get clean

# 安装所需的 Python 包
RUN pip3 install --no-cache-dir \
    requests \
    beautifulsoup4 \
    selenium \
    PyGithub

# 设置容器启动时的默认命令
CMD ["bash"]
