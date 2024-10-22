FROM node:18-alpine AS build

COPY . .

RUN npm install

ENV VITE_SERVER_URL=http://10.108.141.208

RUN npm run build

#############################################

FROM nginx:alpine

COPY --from=build /dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
