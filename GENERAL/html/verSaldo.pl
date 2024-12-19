#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $q = CGI->new;
print $q->header('application/json');

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
}

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare('SELECT SUM(cantidad) FROM transacciones');
$sth->execute();

# Recuperar el saldo
my ($saldo) = $sth->fetchrow_array;

# Si no hay saldo, asignar 0
$saldo //= 0;

# Devolver el saldo en formato JSON
print encode_json({ success => 1, saldo => $saldo });

$sth->finish;
$dbh->disconnect;
