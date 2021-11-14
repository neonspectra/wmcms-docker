# Built from the default nginx image, which is built on debian.
# The way to run the built image to view your site as http://localhost is: docker run -d -p 80:80 nginx:wmcms
# I'll let you figure out how you want to handle turning this into a publicly-facing website using your container registry or reverse proxy frontend of choice. It should be as simple as exposing this container on port 80 and pointing your reverse proxy to it.
FROM nginx:latest

# Nginx's official docker image does not ship with the extra modules that most distros include by default. We need these to power some of the core site functionality in wmcms
RUN apt-get update && apt-get install -y nginx-extras && rm -rf /var/lib/apt/lists/*

# Delete all the default configs so we can replace them with our own
RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/default

# Copy our nginx config file over with our site settings
COPY site/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the actual site contents over
ADD site/html /usr/share/nginx/html
