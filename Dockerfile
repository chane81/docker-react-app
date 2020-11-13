# builder
FROM node:alpine as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build


# nginx
# FROM nginx
# EXPOSE 80
# COPY --from=builder /usr/src/app/build /usr/share/nginx/html
FROM nginx
EXPOSE 3000
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build  /usr/share/nginx/html