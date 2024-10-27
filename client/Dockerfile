FROM node:18-alpine AS build

COPY . .

RUN npm install

ENV VITE_SERVER_URL=http://a7f90be12121c491396707310341fc94-747455972.eu-west-3.elb.amazonaws.com

RUN npm run build

#############################################

FROM nginx:alpine

COPY --from=build /dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
