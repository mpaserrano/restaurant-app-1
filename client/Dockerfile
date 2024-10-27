FROM node:18-alpine AS build

COPY . .

RUN npm install

ENV VITE_SERVER_URL=http://a9b8bb81c66044a979f6da9062aad305-52582312.eu-west-3.elb.amazonaws.com

RUN npm run build

#############################################

FROM nginx:alpine

COPY --from=build /dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
