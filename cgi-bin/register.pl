#!/usr/bin/perl
use CGI;
use DBI;

# Crear objeto CGI
my $q = CGI->new;
print $q->header;

# Conectar a la base de datos
my $dbh = DBI->connect("DBI:mysql:finance_db;host=mariadb", "root", "santiago81", { RaiseError => 1, AutoCommit => 1 });

# Obtener datos del formulario
my $username = $q->param('username');
my $password = $q->param('password');

# Validar si el usuario ya existe
my $sth = $dbh->prepare("SELECT * FROM users WHERE username = ?");
$sth->execute($username);

if (my $row = $sth->fetchrow_hashref) {
    print "<p>El nombre de usuario ya está en uso. Por favor, elija otro.</p>";
} else {
    # Si no existe, insertar el nuevo usuario
    my $insert = $dbh->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    $insert->execute($username, $password);
    print "<p>Registro exitoso. Ahora puede iniciar sesión.</p>";
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;