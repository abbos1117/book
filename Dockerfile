# Use the official PHP image as the base image
FROM php:8.1-cli

# Install required extensions (e.g., mysqli, pdo, etc.)
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the PHP project files into the container
COPY . /var/www/html

# Expose port 8000
EXPOSE 7005

# Command to run the built-in PHP server
CMD ["php", "-S", "0.0.0.0:7005"]
