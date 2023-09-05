# Use an official WordPress image as the base image
FROM wordpress:latest

# Set environment variables for MySQL
ARG MYSQL_DATABASE=mydb
ARG MYSQL_USER=sur
ARG MYSQL_PASSWORD=LearnEarn1M$
ARG MYSQL_HOST=myrds-instance

# Install PHP extensions required for WordPress
RUN docker-php-ext-install mysqli

# Set the working directory to the WordPress root directory
WORKDIR /var/www/html

# Copy your WordPress files to the container (assuming they are in the same directory as the Dockerfile)
COPY . .

# Change ownership of the WordPress files to the web server user
RUN chown -R www-data:www-data .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Define the entry point and command to start Apache
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]