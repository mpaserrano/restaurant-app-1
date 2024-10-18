FROM node:18-alpine AS build

RUN apt-get update && apt-get install -y curl

COPY . .

RUN npm install

EXPOSE 6001

CMD [ "npm", "start" ]
