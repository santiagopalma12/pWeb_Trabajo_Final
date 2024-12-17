#!/usr/bin/perl
use CGI;
use DBI;
use JSON;

# Crear objeto CGI
my $q = CGI->new;
print $q->header('text/html; charset=UTF-8');  # Establecer tipo de contenido como HTML

# Verificar si es una solicitud POST (cuando se envía el formulario)
if ($q->request_method eq 'POST') {
    # Obtener los datos del formulario
    my $name = $q->param('name');
    my $email = $q->param('email');
    my $password = $q->param('password');

    # Mostrar los datos recibidos (para depuración)
    print "Nombre: $name, Correo: $email, Contraseña: $password\n";

    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:finance_manager;host=localhost", "root", "santiago81", { RaiseError => 1, AutoCommit => 1 })
        or die "No se pudo conectar a la base de datos: " . DBI->errstr;

    # Verificar si el correo ya existe en la base de datos
    my $sth = $dbh->prepare("SELECT 1 FROM users WHERE email = ?");
    $sth->execute($email);

    # Si el correo ya está registrado, devolver un error en formato JSON
    if (my $row = $sth->fetchrow_array) {
        print $q->header('application/json');  # Responder con JSON
        print to_json({ status => 'error', message => 'El correo ya está registrado, intente con otro correo.' });
    } else {
        # Si el correo no existe, insertar los datos del nuevo usuario
        my $insert_sth = $dbh->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
        $insert_sth->execute($name, $email, $password);

        # Responder con éxito en formato JSON
        print $q->header('application/json');
        print to_json({ status => 'success', message => 'Registro exitoso. Redirigiendo...' });
    }

    # Cerrar la conexión a la base de datos
    $sth->finish;
    $dbh->disconnect;
} else {
    # Si no es una solicitud POST, mostrar el formulario de registro
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>REGISTRO</h1>
    <form id="register-form" method="POST">
        <label for="name">Nombre:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="email">Correo electrónico:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="password">Contraseña:</label>
        <input type="password" id="password" name="password" required><br><br>

        <button type="submit">Registrarse</button>
    </form>

    <p id="error-message" style="color: red; display: none;"></p>

    <script>
        $(document).ready(function(){
            $('#register-form').on('submit', function(event) {
                event.preventDefault();

                var name = $('#name').val();
                var email = $('#email').val();
                var password = $('#password').val();

                $.ajax({
                    url: 'register.pl',
                    type: 'POST',
                    data: {
                        name: name,
                        email: email,
                        password: password
                    },
                    success: function(response) {
                        if(response.status === 'error') {
                            $('#error-message').text(response.message).show();
                        } else {
                            window.location.href = '/login.html'; // Redirigir a la página de login después del registro
                        }
                    },
                    error: function() {
                        $('#error-message').text('Hubo un error en la solicitud. Intente de nuevo.').show();
                    }
                });
            });
        });
    </script>
</body>
</html>
HTML
}
