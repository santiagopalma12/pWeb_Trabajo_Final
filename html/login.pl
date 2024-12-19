#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

# Inicializar CGI
my $q = CGI->new;
print $q->header('application/json');

# Obtener los parámetros de usuario y contraseña
my $username = $q->param('username');
my $password = $q->param('password');

# Verificar que los parámetros no estén vacíos
if (!$username || !$password) {
    print encode_json({ success => 0, message => "Usuario o contraseña no proporcionados." });
    exit;
}

# Definir los parámetros de la base de datos
my $dsn      = "DBI:mysql:database=gestor_finanzas;host=mariadb-container;port=3306";
my $db_user  = "root";
my $db_pass  = "santiago81";

# Conectar a la base de datos
my $dbh;
eval {
    $dbh = DBI->connect($dsn, $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 });
};
if ($@) {
    print encode_json({ success => 0, message => "Error al conectar a la base de datos: $@" });
    exit;
} else {
    print encode_json({ success => 1, message => "Conexión exitosa a la base de datos" });
}

# Preparar la consulta para verificar el usuario y la contraseña
my $sth = $dbh->prepare('SELECT * FROM usuarios WHERE username = ? AND password = ?');
$sth->execute($username, $password);

# Verificar si se encontraron resultados
my $user_exists = $sth->fetchrow_array;

if ($user_exists) {
    # Si las credenciales son correctas, devolver éxito
    print encode_json({ success => 1 });
} else {
    # Si las credenciales son incorrectas, devolver error
    print encode_json({ success => 0, message => "Usuario o contraseña incorrectos." });
}

# Limpiar y cerrar la conexión
$sth->finish;
$dbh->disconnect;
