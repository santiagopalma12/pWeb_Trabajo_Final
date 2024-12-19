# Usar Ubuntu 20.04 LTS como imagen base
FROM ubuntu:20.04

# Configurar el entorno
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar el sistema e instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    apache2 \
    perl \
    libapache2-mod-perl2 \
    mariadb-client \
    cpanminus \
    libmariadb-dev \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar módulos Perl adicionales con cpanm
RUN cpanm --notest CGI DBI JSON DBD::MariaDB

# Copiar los archivos del proyecto al directorio web de Apache
COPY ./html /var/www/html/
COPY apache-config/000-default.conf /etc/apache2/sites-available/000-default.conf
# Eliminar la página predeterminada de Apache
RUN rm /var/www/html/index.html

# Configurar permisos de los archivos
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod +x /var/www/html/*.pl

# Habilitar CGI en Apache
RUN a2enmod cgi

# Configurar Apache para permitir ejecución de scripts CGI
RUN echo "<Directory /var/www/html/>" >> /etc/apache2/apache2.conf && \
    echo "  Options +Indexes +FollowSymLinks +ExecCGI" >> /etc/apache2/apache2.conf && \
    echo "  AllowOverride None" >> /etc/apache2/apache2.conf && \
    echo "  Require all granted" >> /etc/apache2/apache2.conf && \
    echo "</Directory>" >> /etc/apache2/apache2.conf && \
    echo "AddHandler cgi-script .pl" >> /etc/apache2/apache2.conf && \
    echo "DirectoryIndex echo.pl" >> /etc/apache2/apache2.conf

# Exponer el puerto 80 para Apache
EXPOSE 80

# Iniciar Apache cuando el contenedor se ejecute
CMD ["apache2ctl", "-D", "FOREGROUND"]
