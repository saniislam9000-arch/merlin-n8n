FROM node:20-bookworm-slim

# Install Chrome and dependencies
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates curl \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [url=http://dl.google.com/linux/chrome/deb/] stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json .
RUN npm install && npm install playwright

# Install Playwright system deps and Chromium
RUN npx playwright install-deps chromium
RUN npx playwright install chromium

COPY . .

ENV N8N_PORT=8080
ENV N8N_PROTOCOL=https

EXPOSE 8080

CMD ["npm", "start"]
