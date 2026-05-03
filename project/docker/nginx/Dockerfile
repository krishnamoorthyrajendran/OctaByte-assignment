FROM nginx
WORKDIR /var/app
COPY /project/docker/nginx/default.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]