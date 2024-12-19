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
my $tipo        = $cgi->param('tipo');        # Ingreso o Gasto
my $cantidad    = $cgi->param('cantidad');    # Cantidad de la transacción
my $descripcion = $cgi->param('descripcion'); # Descripción de la transacción

# Verificar si los parámetros están presentes
if (!$tipo || !$cantidad || !$descripcion) {
    print encode_json({
        success => 0,
        message => "Faltan datos en el formulario: tipo, cantidad o descripción no están presentes."
    });
    exit;
}

# Depuración: Mostrar valores recibidos
warn "Recibidos -> Tipo: $tipo, Cantidad: $cantidad, Descripción: $descripcion\n";

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

# Preparar e insertar datos en la base de datos
my $sth;
eval {
    $sth = $dbh->prepare("INSERT INTO transacciones (tipo, cantidad, descripcion, fecha) VALUES (?, ?, ?, ?)");
    $sth->execute($tipo, $cantidad, $descripcion, $fecha_actual);
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
        message => "Transacción registrada correctamente."
    });
} else {
    print encode_json({
        success => 0,
        message => "Error: No se pudo registrar la transacción."
    });
}

# Cerrar conexiones
$sth->finish if $sth;
$dbh->disconnect if $dbh;

warn "Conexión cerrada correctamente.\n";
