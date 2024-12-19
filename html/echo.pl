#!/usr/bin/env perl

use strict;
use warnings;

print "Content-type: text/html\n\n";
print <<EOF;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión Financiera</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <div class="container" style="max-width: 400px; margin-top: 50px;">
        <div id="loginForm">
            <h2 class="text-center mb-4">Iniciar Sesión</h2>
            <form id="loginFormSubmit">
                <div class="mb-3">
                    <label for="username" class="form-label">Usuario</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Iniciar Sesión</button>
            </form>
            <p class="text-center mt-3">¿No tienes cuenta? <button id="btnRegistrar" class="btn btn-link">Regístrate aquí</button></p>
        </div>

        <div id="registerForm" style="display:none;">
            <h2 class="text-center mb-4">Registrar Cuenta</h2>
            <form id="registerFormSubmit">
                <div class="mb-3">
                    <label for="regUsername" class="form-label">Usuario</label>
                    <input type="text" class="form-control" id="regUsername" name="username" required>
                </div>
                <div class="mb-3">
                    <label for="regPassword" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="regPassword" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Registrar</button>
            </form>
            <p class="text-center mt-3">¿Ya tienes cuenta? <button id="btnLogin" class="btn btn-link">Inicia sesión aquí</button></p>
        </div>

        <div id="responseMessage"></div> <!-- Mensajes de respuesta -->
    </div>

    <script src="script4.js"></script>
    <script src="script5.js"></script>
</body>
</html>
EOF
