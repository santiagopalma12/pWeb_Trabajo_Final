#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $q = CGI->new;
print $q->header('application/json');

my $username = $q->param('username');  # Nombre de usuario
my $password = $q->param('password');  # Contraseña

# Comprobar si ambos parámetros están presentes
if (!$username || !$password) {
    print encode_json({
        success => 0,
        message => "Faltan datos: nombre de usuario o contraseña."
    });
    exit;
}

my $dsn     = "DBI:mysql:database=usuarios;host=mariadb-container;port=3306";
my $db_user = "root";
my $db_pass = "santiago81";

# Conectar a la base de datos
my $dbh;
eval {
    $dbh = DBI->connect($dsn, $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 });
};
if ($@) {
    print encode_json({ success => 0, message => "Error al conectar a la base de datos: $@" });
    exit;
}

# Verificar si el nombre de usuario existe en la base de datos
my $sth = $dbh->prepare("SELECT password FROM users WHERE username = ?");
$sth->execute($username);

# Recuperar la contraseña de la base de datos
my ($db_password) = $sth->fetchrow_array;

# Si no se encuentra el usuario
if (!$db_password) {
    print encode_json({
        success => 0,
        message => "Usuario no encontrado."
    });
    $sth->finish;
    $dbh->disconnect;
    exit;
}

# Comparar las contraseñas (aquí podrías agregar una comparación segura con hashes, pero por simplicidad estamos comparando texto claro)
if ($password eq $db_password) {
    print encode_json({
        success => 1,
        message => "Login exitoso."
    });
} else {
    print encode_json({
        success => 0,
        message => "Contraseña incorrecta."
    });
}

$sth->finish;
$dbh->disconnect;
