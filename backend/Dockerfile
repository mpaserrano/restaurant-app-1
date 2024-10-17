FROM node:18-alpine AS build

COPY . .

RUN npm install

EXPOSE 6001

CMD [ "npm", "start" ]
