ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

# Install gettext, which includes envsubst
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Copy the nginx.conf template to the /tmp directory in the container
COPY nginx.conf.template /tmp/nginx.conf.template