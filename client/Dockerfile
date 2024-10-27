FROM node:18-alpine AS build

COPY . .

RUN npm install

ENV VITE_SERVER_URL=http://ab4850d2aecaa4afdb0e5df61392e6dd-1016574668.eu-west-3.elb.amazonaws.com

RUN npm run build

#############################################

FROM nginx:alpine

COPY --from=build /dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
