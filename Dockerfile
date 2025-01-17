# Base image for Docker registry
FROM registry:2

# Install required utilities for htpasswd and Nginx
RUN apt-get update && apt-get install -y apache2-utils nginx

# Set environment variables for authentication
ENV REGISTRY_AUTH=htpasswd
ENV REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"
ENV REGISTRY_AUTH_HTPASSWD_PATH="/auth/htpasswd"
ENV REGISTRY_USER="admin"
ENV REGISTRY_PASSWORD="password"

# Create the necessary directories
RUN mkdir -p /etc/docker/registry /auth /var/lib/registry /etc/nginx/sites-available /etc/nginx/sites-enabled

# Create the htpasswd file for authentication using the provided environment variables
RUN echo "$REGISTRY_USER:$(htpasswd -nbB $REGISTRY_USER $REGISTRY_PASSWORD | cut -d: -f2)" > /auth/htpasswd
