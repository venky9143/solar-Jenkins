FROM node:18
WORKDIR /app
COPY package*.json /app
RUN ls -l /app
RUN npm cache clean --force && npm install --legacy-peer-deps
COPY . .
EXPOSE  3000
CMD [ "npm", "start" ]
