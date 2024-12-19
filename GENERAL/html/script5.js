$(document).ready(function () {
    // Al hacer clic en el botón de registro, cambia el formulario
    $('#btnRegistrar').click(function () {
        $('#loginForm').hide(); // Oculta el formulario de login
        $('#registerForm').show(); // Muestra el formulario de registro
    });

    // Al enviar el formulario de registro
    $('#registerForm').submit(function (e) {
        e.preventDefault(); // Evita el envío por defecto del formulario

        var username = $('#regUsername').val();
        var password = $('#regPassword').val();

        // Enviar los datos de registro usando AJAX
        $.ajax({
            url: 'register.pl', // Aquí se ejecutará el archivo register.pl
            type: 'POST',
            data: {
                username: username,
                password: password
            },
            success: function (response) {
                // Muestra un mensaje o redirige si el registro fue exitoso
                $('#responseMessage').html("<div class='alert alert-success'>Registro exitoso. Redirigiendo...</div>");
                // Redirige a la página principal o cualquier otra página
                setTimeout(function () {
                    window.location.href = 'dashboard.pl'; // Cambia esta URL a la que desees
                }, 2000);
            },
            error: function () {
                $('#responseMessage').html("<div class='alert alert-danger'>Hubo un error en el registro.</div>");
            }
        });
    });

    // Mostrar el formulario de login cuando se quiera
    $('#btnLogin').click(function () {
        $('#registerForm').hide(); // Oculta el formulario de registro
        $('#loginForm').show(); // Muestra el formulario de login
    });
});
