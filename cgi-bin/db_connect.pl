#!/usr/bin/env perl

use strict;
use warnings;
use DBI;

# Configuración de la base de datos
my $db_name     = "finance_manager";
my $db_host     = "mariadb";
my $db_user     = "root";
my $db_password = "santiago81";

# Subrutina para conectar a la base de datos
sub connect_to_db {
    my $dbh = DBI->connect("DBI:MariaDB:database=$db_name;host=$db_host", $db_user, $db_password, {
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 1,
    }) or die "Error al conectar a la base de datos: $DBI::errstr\n";
    
    return $dbh;
}

1;  # Finaliza el módulo
