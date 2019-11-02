FROM nginx:1.17.5-alpine

# Add the conf file to the container
ADD default /etc/nginx/conf.d/default.conf

# Add helper files in case they're needed
COPY h5bp /etc/nginx/h5bp

# Add contact information
LABEL maintainer="Ben Freke (github.com/benfreke)"

# http and https enable
EXPOSE 80 443

# Default command to always run
CMD ["nginx", "-g", "daemon off;"]
