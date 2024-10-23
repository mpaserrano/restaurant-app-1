FROM node:18-alpine AS build

COPY . .

RUN npm install

ENV VITE_SERVER_URL=http://a01d5fd4e7bbb47358ea1ca90918026e-8424808.eu-west-3.elb.amazonaws.com

RUN npm run build

#############################################

FROM nginx:alpine

COPY --from=build /dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
