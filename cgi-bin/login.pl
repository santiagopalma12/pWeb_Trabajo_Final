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

# Validar el usuario y la contraseña
my $sth = $dbh->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
$sth->execute($username, $password);

# Verificar si el usuario existe
if (my $row = $sth->fetchrow_hashref) {
    # Si el usuario es válido, iniciar sesión
    print $q->redirect('/dashboard.html');
} else {
    # Si las credenciales son incorrectas, mostrar error
    print "<p>Inicio de sesión fallido. Por favor, verifique su nombre de usuario y contraseña.</p>";
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;