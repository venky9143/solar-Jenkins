FROM node:latest
WORKDIR /app
COPY packaage.*json /app
RUN npm install
COPY . .
EXPOSE  3000
CMD [ "npm", "start" ]
