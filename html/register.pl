#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;         # Para manejar JSON
use POSIX 'strftime';  # Para manejar la fecha y hora

# Inicializar CGI
my $cgi = CGI->new;

# Configurar cabecera HTTP para JSON
print $cgi->header(-type => 'application/json', -charset => 'UTF-8');

# Recuperar los datos del formulario
my $username = $cgi->param('username');  # Nombre de usuario
my $password = $cgi->param('password');  # Contraseña

# Verificar si los parámetros están presentes
if (!$username || !$password) {
    print encode_json({
        success => 0,
        message => "Faltan datos en el formulario: nombre de usuario o contraseña no están presentes."
    });
    exit;
}

# Depuración: Mostrar valores recibidos
warn "Recibidos -> Usuario: $username, Contraseña: $password\n";

# Obtener la fecha actual
my $fecha_actual = strftime "%Y-%m-%d %H:%M:%S", localtime;

# Configuración de la base de datos
my $dsn      = "DBI:mysql:database=gestor_finanzas;host=mariadb-container;port=3306";
my $db_user  = "root";
my $db_pass  = "santiago81";

# Conectar a la base de datos
my $dbh;
eval {
    $dbh = DBI->connect($dsn, $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 });
    warn "Conexión a la base de datos exitosa.\n";
};
if ($@) {
    print encode_json({
        success => 0,
        message => "Error al conectar a la base de datos: $@"
    });
    exit;
}

# Verificar si la base de datos se ha conectado correctamente
if (!$dbh) {
    print encode_json({
        success => 0,
        message => "No se pudo conectar a la base de datos."
    });
    exit;
}

# Verificar si el usuario ya existe en la base de datos
my $sth_check;
eval {
    $sth_check = $dbh->prepare("SELECT COUNT(*) FROM usuarios WHERE username = ?");
    $sth_check->execute($username);
};
if ($@) {
    print encode_json({
        success => 0,
        message => "Error al verificar si el usuario existe: $@"
    });
    $dbh->disconnect if $dbh;
    exit;
}

# Si el usuario ya existe, devolver mensaje de error
my ($user_exists) = $sth_check->fetchrow_array;
if ($user_exists > 0) {
    print encode_json({
        success => 0,
        message => "El nombre de usuario ya está en uso."
    });
    exit;
}

# Preparar e insertar el nuevo usuario en la base de datos
my $sth;
eval {
    $sth = $dbh->prepare("INSERT INTO usuarios (username, password, fecha_registro) VALUES (?, ?, ?)");
    $sth->execute($username, $password, $fecha_actual);
    warn "Inserción de datos exitosa.\n";
};
if ($@) {
    print encode_json({
        success => 0,
        message => "Error al insertar los datos en la base de datos: $@"
    });
    $dbh->disconnect if $dbh;
    exit;
}

# Verificar si la inserción fue exitosa
if ($sth->rows > 0) {
    print encode_json({
        success => 1,
        message => "Usuario registrado correctamente."
    });
} else {
    print encode_json({
        success => 0,
        message => "Error: No se pudo registrar el usuario."
    });
}

# Cerrar conexiones
$sth->finish if $sth;
$sth_check->finish if $sth_check;
$dbh->disconnect if $dbh;

warn "Conexión cerrada correctamente.\n";
