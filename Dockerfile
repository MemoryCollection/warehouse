FROM python:latest

# Set the Chrome version
ENV CHROME_VERSION 126.0.6478.61
ENV CHROMEDRIVER_VERSION ${CHROME_VERSION}

# Install required tools and libraries
RUN apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends \
    curl unzip gnupg wget libglib2.0-0 libx11-6 libnss3 && \
    rm -rf /var/lib/apt/lists/*

# Install Chrome WebDriver
RUN mkdir -p /opt/chromedriver-${CHROMEDRIVER_VERSION} && \
    curl -sS -o /tmp/chromedriver_linux64.zip https://storage.googleapis.com/chrome-for-testing-public/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-${CHROMEDRIVER_VERSION} && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-${CHROMEDRIVER_VERSION}/chromedriver-linux64/chromedriver && \
    ln -fs /opt/chromedriver-${CHROMEDRIVER_VERSION}/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb && \
    apt install -y /tmp/chrome.deb && \
    rm /tmp/chrome.deb

# Set working directory
WORKDIR /app
COPY app /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set container to idle on start
CMD ["tail", "-f", "/dev/null"]
