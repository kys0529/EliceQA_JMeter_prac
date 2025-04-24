FROM jenkins/jenkins:lts

USER root

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    curl unzip git wget gnupg2 \
    software-properties-common apt-transport-https \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 libxss1 \
    libappindicator1 libasound2 libatk-bridge2.0-0 libgtk-3-0 \
    xvfb chromium chromium-driver \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Chrome & ChromeDriver 자동 설치
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d. -f1-3) && \
    DRIVER_VERSION="134.0.6998.90" && \
    wget -q "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip" -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf /tmp/chromedriver.zip

RUN python3 -m pip install --upgrade pip --break-system-packages
RUN pip install selenium pytest selenium_stealth --break-system-packages

USER jenkins
