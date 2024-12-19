$(document).ready(function () {
    $('#loginForm').submit(function (e) {
        e.preventDefault(); // Evita el envío por defecto del formulario

        var username = $('#username').val();
        var password = $('#password').val();

        // Validar las credenciales (puedes hacer una llamada AJAX aquí si es necesario)
        if (username === "usuario" && password === "contraseña") {
            // Redirigir al usuario a otra página
            window.location.href = "dashboard.pl"; // Cambia esta URL a la página a la que deseas redirigir
        } else {
            // Mostrar mensaje de error si las credenciales no son válidas
            $('#responseMessage').html("<div class='alert alert-danger'>Usuario o contraseña incorrectos.</div>");
        }
    });
});
