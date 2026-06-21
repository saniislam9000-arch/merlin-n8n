FROM node:20-bookworm-slim

# Install dependencies for Chrome
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome properly
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json .
RUN npm install

# Install Playwright with Chromium
RUN npm install playwright \
    && npx playwright install-deps chromium \
    && npx playwright install chromium

COPY . .

ENV N8N_PORT=8080
ENV N8N_PROTOCOL=https

EXPOSE 8080

CMD ["npm", "start"]
