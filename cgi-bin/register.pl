#!/usr/bin/perl
use CGI;
use DBI;
use JSON;

# Crear objeto CGI
my $q = CGI->new;

# Verificar si es una solicitud POST (cuando se envía el formulario)
if ($q->request_method eq 'POST') {
    # Configurar encabezado JSON
    print $q->header('application/json; charset=UTF-8');

    # Obtener los datos del formulario
    my $name = $q->param('name');
    my $email = $q->param('email');
    my $password = $q->param('password');

    # Verificar que se reciban los datos
    if (!$name || !$email || !$password) {
        print to_json({ status => 'error', message => 'Todos los campos son obligatorios.' });
        exit;
    }

    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:finance_manager;host=localhost", "root", "santiago81",
        { RaiseError => 1, AutoCommit => 1 });

    # Verificar si el correo ya existe en la base de datos
    my $sth = $dbh->prepare("SELECT 1 FROM users WHERE email = ?");
    $sth->execute($email);

    if ($sth->fetchrow_array) {
        # Correo ya registrado
        print to_json({ status => 'error', message => 'El correo ya está registrado. Intente con otro.' });
    } else {
        # Si el correo no existe, insertar los datos del nuevo usuario
        my $insert_sth = $dbh->prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
        if ($insert_sth->execute($name, $email, $password)) {
            print to_json({ status => 'success', message => 'Usuario registrado exitosamente.' });
        } else {
            print to_json({ status => 'error', message => 'Error al registrar el usuario. Intente nuevamente.' });
        }
    }

    # Cerrar la conexión a la base de datos
    $sth->finish;
    $dbh->disconnect;
} else {
    # Mostrar el formulario de registro
    print $q->header('text/html; charset=UTF-8');
    print <<'HTML';
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>Registro</h1>
    <form id="register-form">
        <label for="name">Nombre:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="email">Correo electrónico:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="password">Contraseña:</label>
        <input type="password" id="password" name="password" required><br><br>

        <button type="submit">Registrarse</button>
    </form>

    <p id="error-message" style="color: red; display: none;"></p>
    <p id="success-message" style="color: green; display: none;"></p>

    <script>
        $(document).ready(function(){
            $('#register-form').on('submit', function(event) {
                event.preventDefault(); // Evitar el envío directo del formulario

                var name = $('#name').val();
                var email = $('#email').val();
                var password = $('#password').val();

                // Hacer la solicitud AJAX
                $.ajax({
                    url: 'register.pl', // Ruta al script Perl
                    type: 'POST',
                    data: {
                        name: name,
                        email: email,
                        password: password
                    },
                    success: function(response) {
                        console.log(response); // Depurar en la consola

                        if (response.status === 'error') {
                            $('#success-message').hide();
                            $('#error-message').text(response.message).show();
                        } else if (response.status === 'success') {
                            $('#error-message').hide();
                            $('#success-message').text(response.message).show();

                            // Redirigir después de 2 segundos
                            setTimeout(function() {
                                window.location.href = '/login.html';
                            }, 2000);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error:", error); // Mostrar error en consola
                        $('#success-message').hide();
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
