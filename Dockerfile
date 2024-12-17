FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualiza e instala los paquetes necesarios
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

# Instalar los módulos de Perl
RUN cpanm --notest CGI DBI JSON DBD::MariaDB

# Copiar los archivos HTML y JS a la carpeta correspondiente en el contenedor
COPY ./public /var/www/html/

# Copiar los scripts Perl (CGI) al contenedor
COPY ./cgi-bin /usr/lib/cgi-bin/

# Copiar la base de datos de configuración (si es necesario)
COPY ./database/setup.sql /root/setup.sql

# Cambiar permisos en los archivos
RUN chown -R www-data:www-data /var/www/html /usr/lib/cgi-bin && \
    chmod -R 755 /var/www/html /usr/lib/cgi-bin && \
    chmod +x /usr/lib/cgi-bin/*.pl

# Habilitar modulos de Apache para CGI
RUN a2enmod cgi

# Configurar el servidor web
RUN echo "<Directory /var/www/html/>" >> /etc/apache2/apache2.conf && \
    echo "  Options +Indexes +FollowSymLinks +ExecCGI" >> /etc/apache2/apache2.conf && \
    echo "  AllowOverride None" >> /etc/apache2/apache2.conf && \
    echo "  Require all granted" >> /etc/apache2/apache2.conf && \
    echo "</Directory>" >> /etc/apache2/apache2.conf && \
    echo "AddHandler cgi-script .pl" >> /etc/apache2/apache2.conf && \
    echo "DirectoryIndex login.html" >> /etc/apache2/apache2.conf

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]
