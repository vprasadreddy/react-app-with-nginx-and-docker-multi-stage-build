FROM node:alpine AS build
WORKDIR /app
COPY package.json /app/package.json
RUN npm i
COPY . /app/
RUN npm run build

# production environment
FROM nginx:stable-alpine
RUN apk add --no-cache gettext
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
COPY env-config.js.template /usr/share/nginx/html/
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 80