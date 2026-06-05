FROM node:alpine AS build
WORKDIR /app
COPY package.json /app/package.json
RUN npm i
COPY . /app/
#EXPOSE 3000
RUN npm run build
#CMD ["npm", "start"]

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
#CMD ["nginx", "-g", "daemon off;"]