# First stage builder
FROM node:alpine as builder
# Changes container work-directory
WORKDIR '/app'
# Pre-copies the package.json that will mainly be changed when developing
COPY package.json .
RUN npm install
# Copies all the files/dependencies
COPY . .
# Starts the following service in the container
RUN npm run build

# Passing the final results from builder to the next phase (Nginx)
FROM nginx
# Exposes the container port for AWS Elastic Beanstalk app service to listen to port 80:
EXPOSE 80
# copies the build items and Nginx will present the static content after this
COPY --from=builder /app/build /usr/share/nginx/html
# P.S no need to start the service manually,
# nginx will take care of it for us and it will start presenting the content
CMD ["nginx", "-g", "daemon off;"]