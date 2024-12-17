#!/usr/bin/perl
use CGI;
use DBI;

# Crear objeto CGI
my $q = CGI->new;

# Solo procesar si es una solicitud AJAX (si es POST)
if ($q->request_method eq 'POST') {
    # Obtener datos del formulario (pasados por AJAX)
    my $username = $q->param('username');
    my $password = $q->param('password');

    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:finance_manager;host=localhost", "root", "santiago81", { RaiseError => 1, AutoCommit => 1 });

    # Validar el usuario y la contraseña
    my $sth = $dbh->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
    $sth->execute($username, $password);

    # Verificar si el usuario existe
    if (my $row = $sth->fetchrow_hashref) {
        # Si el usuario es válido, devolver un mensaje de éxito
        print $q->header('application/json');
        print '{"status":"success"}';
    } else {
        # Si las credenciales son incorrectas, devolver un mensaje de error
        print $q->header('application/json');
        print '{"status":"error", "message":"Inicio de sesión fallido. Verifique su nombre de usuario y contraseña."}';
    }

    # Cerrar la conexión
    $sth->finish;
    $dbh->disconnect;
} else {
    # Si no es una solicitud AJAX, mostrar el formulario
    print $q->header;
    print $q->start_html("Login - Pienza en grande");
    print "<h1>Pienza en grande</h1>";
    print "<img src='/ruta/a/tu/imagen.jpg' alt='Imagen de referencia'>";
    print "<form id='loginForm'>";
    print "<label for='username'>Correo:</label><br>";
    print "<input type='email' id='username' name='username' required><br><br>";
    print "<label for='password'>Contraseña:</label><br>";
    print "<input type='password' id='password' name='password' required><br><br>";
    print "<input type='submit' value='Ingresar'>";
    print "<input type='button' value='Registrarse' onclick='window.location.href=\"register.pl\"'><br><br>";
    print "<p id='error-message' style='color:red;'></p>";  # Mensaje de error

    print "</form>";

    # Aquí va el bloque de JavaScript
    print <<'END_JS';
<script>
    // Manejar el evento de envío del formulario
    document.getElementById('loginForm').addEventListener('submit', function(event) {
        event.preventDefault();  // Evitar la recarga de la página

        var username = document.getElementById('username').value;
        var password = document.getElementById('password').value;

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'login.pl', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

        // Enviar los datos de manera asíncrona
        xhr.send('username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password));

        // Cuando la respuesta se recibe
        xhr.onload = function() {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.status === 'success') {
                    // Si el login es exitoso, redirigir a la página de inicio
                    window.location.href = '/dashboard.html';
                } else {
                    // Si hay un error, mostrar el mensaje en el HTML
                    document.getElementById('error-message').innerText = response.message;
                }
            }
        };
    });
</script>
END_JS

    print $q->end_html;
}
