# Stage 1: Build the htpasswd file
FROM debian:bullseye-slim AS build

# Install apache-utils to generate htpasswd file
RUN apt-get update && apt-get install -y apache2-utils

# Set environment variables for authentication
ENV REGISTRY_USER=$REGISTRY_USER
ENV REGISTRY_PASSWORD=$REGISTRY_PASSWORD

# Create the htpasswd file for authentication using the provided environment variables
RUN mkdir -p /auth && \
    echo "$REGISTRY_USER:$(htpasswd -nbB $REGISTRY_USER $REGISTRY_PASSWORD | cut -d: -f2)" > /auth/htpasswd

# Stage 2: Final registry image
FROM registry:2

# Copy the htpasswd file from the build stage
COPY --from=build /auth /auth

# Set environment variables for registry authentication
ENV REGISTRY_AUTH=htpasswd
ENV REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"
ENV REGISTRY_AUTH_HTPASSWD_PATH="/auth/htpasswd"

# Expose the registry port
EXPOSE 5000

# Run the Docker registry with the configuration
CMD ["registry", "serve", "/etc/docker/registry/config.yml"]
