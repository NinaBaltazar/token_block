FROM node:18-alpine

WORKDIR /app/server

COPY package.json package-lock.json ./
RUN npm install

COPY . .

CMD ["node", "server.js"]
