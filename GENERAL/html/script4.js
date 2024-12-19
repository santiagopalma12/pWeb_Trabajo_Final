$(document).ready(function () {
    $('#loginForm').submit(function (e) {
        e.preventDefault(); // Evita el envío por defecto del formulario

        var username = $('#username').val();
        var password = $('#password').val();

        // Muestra mensaje de cargando
        $('#responseMessage').html("<div class='alert alert-info'>Cargando...</div>");

        // Enviar los datos de login usando AJAX
        $.ajax({
            url: 'login.pl',
            type: 'POST',
            data: { username: username, password: password },
            success: function (response) {
                if (response.success) {
                    // Redirige si las credenciales son correctas
                    window.location.href = "dashboard.pl";
                } else {
                    // Muestra un mensaje de error si las credenciales no son válidas
                    $('#responseMessage').html("<div class='alert alert-danger'>" + response.message + "</div>");
                }
            },
            error: function () {
                // Muestra un mensaje si ocurre un error de conexión
                $('#responseMessage').html("<div class='alert alert-danger'>Error de conexión con el servidor.</div>");
            }
        });
    });
});
