#!/usr/bin/env perl

use strict;
use warnings;
use CGI;
use JSON;
use lib "/usr/lib/cgi-bin";  # Ruta donde está db_connect.pl
use db_connect;

my $cgi = CGI->new;

print $cgi->header('application/json');

# Obtener datos del formulario
my $username = $cgi->param('username');
my $password = $cgi->param('password');

# Validar que los datos no estén vacíos
if (!$username || !$password) {
    print encode_json({ success => 0, error => "Usuario y contraseña son obligatorios." });
    exit;
}

# Conectar a la base de datos
my $dbh = db_connect::connect_to_db();

# Verificar si el usuario existe y la contraseña coincide
my $sth = $dbh->prepare("SELECT password FROM users WHERE username = ?");
$sth->execute($username);

my ($stored_password) = $sth->fetchrow_array();

if ($stored_password && $stored_password eq $password) {
    print encode_json({ success => 1, message => "Usuario validado exitosamente." });
} else {
    print encode_json({ success => 0, error => "Usuario o contraseña incorrectos." });
}

$sth->finish();
$dbh->disconnect();
