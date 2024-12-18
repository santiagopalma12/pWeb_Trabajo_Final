#!/usr/bin/perl -w
use CGI;
use DBI;
use JSON;

my $q = CGI->new;
print $q->header('application/json');  # Cambiar la cabecera a JSON

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

# Realizar la consulta para los últimos 5 movimientos
my $sth = $dbh->prepare('SELECT tipo, descripcion, cantidad, fecha FROM transacciones ORDER BY fecha DESC LIMIT 5');
$sth->execute();

my @movimientos;

# Variable para el saldo acumulado
my $saldo_acumulado = 0;

while (my @row = $sth->fetchrow_array) {
    # Actualizar el saldo acumulado según el tipo de transacción
    if ($row[0] eq 'ingreso') {
        $saldo_acumulado += $row[2];
    } elsif ($row[0] eq 'gasto') {
        $saldo_acumulado -= $row[2];
    }

    # Agregar movimiento y saldo a la lista
    push @movimientos, {
        tipo => $row[0],
        descripcion => $row[1],
        cantidad => $row[2],
        fecha => $row[3],
        saldo => $saldo_acumulado
    };
}

# Devolver la respuesta en formato JSON
print encode_json({
    success => 1,
    movimientos => \@movimientos
});

$sth->finish;
$dbh->disconnect;
