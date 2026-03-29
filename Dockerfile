FROM nikolaik/python-nodejs:python3.11-nodejs20
FROM debian:bookworm

RUN if [ -f /etc/apt/sources.list ]; then
  sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list
  sed -i '/security.debian.org/d' /etc/apt/sources.list
fi

apt-get update && \
apt-get install -y --no-install-recommends ffmpeg aria2 && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
apt-get update && \
apt-get install -y --no-install-recommends ffmpeg aria2 && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/

RUN python -m pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update
CMD bash start
