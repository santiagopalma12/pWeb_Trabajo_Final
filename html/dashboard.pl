#!/usr/bin/perl -w

use strict;
use warnings;

print "Content-type: text/html\n\n";
print <<EOF;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión Financiera</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
 <style>
    body {
        background-image: url('../imagenes/fondo_finanzas.jpeg');
        background-size: cover;
        background-position: center center;
        background-repeat: no-repeat;
        color: #495057;
        font-family: 'Roboto', sans-serif;
        margin: 0;
        padding: 0;
        height: 100vh;
    }

    .container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        height: 100%;
        padding: 20px;
        box-sizing: border-box;
    }

    .header {
        text-align: center;
        margin-bottom: 20px;
    }

    h2, h3 {
        color: #343a40;
        font-weight: bold;
    }

    .main-content {
        display: flex;
        justify-content: space-between;
        width: 100%;
        gap: 20px;
        margin-top: 20px; /* Ajuste para separar del header */
    }

    /* Estilos para el saldo */
    .saldo {
        flex: 0 1 30%;
        background: rgba(255, 255, 255, 0.8);
        padding: 15px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        height: auto;
    }

    /* Estilos para el formulario */
    .formulario {
        flex: 1;
        background: rgba(255, 255, 255, 0.8);
        padding: 20px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
    }

    /* Estilos para los últimos movimientos */
    .ultimos-movimientos {
        flex: 0 1 40%;
        background: rgba(255, 255, 255, 0.8);
        padding: 15px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        height: auto;
        overflow-y: auto;
    }

    /* Estilo para las tablas */
    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        padding: 8px;
        text-align: left;
        border: 1px solid #ddd;
    }

    /* Botones */
    .btn-action {
        font-weight: bold;
        border-radius: 20px;
        padding: 12px 25px;
        font-size: 1.1rem;
    }

    .btn-primary {
        background-color: #007bff;
        border: none;
    }

    .btn-danger {
        background-color: #dc3545;
        border: none;
    }

    .alert {
        margin-top: 20px;
    }

    label {
        font-weight: bold;
    }

    .image-header {
        text-align: center;
        margin-bottom: 20px;
    }

    .image-header img {
        max-width: 150px;
    }

    .form-actions {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 20px;
    }
</style>

</head>
   <div class="container">
        <div class="header">
            <div class="image-header">
                <img src="../imagenes/image_finanzas.png" alt="Gestión Financiera"> 
            </div>
            <h2 class="text-center mb-4">Gestión Financiera</h2>
        </div>

        <div class="main-content">
            <!-- Saldo Actual -->
            <div class="saldo">
                <h3>Saldo Actual</h3>
                <div id="saldoContenido" style="margin-top: 20px;">
                    <!-- El saldo será mostrado aquí después de hacer la solicitud -->
                </div>
                
                <!-- Gráfico de evolución de saldo -->
                <canvas id="saldoChart" width="400" height="200"></canvas>
            </div>

            <!-- Formulario para Registrar Transacción -->
            <div class="formulario">
                <h3>Registrar Transacción</h3>
                <form id="formInsertar" method="POST">
                    <div class="mb-3">
                        <label for="tipo">Tipo:</label>
                        <select class="form-select" id="tipo" name="tipo" required>
                            <option value="ingreso">Ingreso</option>
                            <option value="gasto">Gasto</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="descripcion">Descripción:</label>
                        <input type="text" class="form-control" id="descripcion" name="descripcion" required>
                    </div>
                    <div class="mb-3">
                        <label for="cantidad">Cantidad:</label>
                        <input type="number" step="0.01" class="form-control" id="cantidad" name="cantidad" required>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-primary btn-action" id="submitAJAXInsertar">Registrar</button>
                    </div>
                </form>
                <div id="respInsertar" class="alert" style="display:none;"></div>
            </div>

            <!-- Últimos Movimientos -->
            <div class="ultimos-movimientos">
                <h3>Últimos Movimientos</h3>
                <div id="ultimosMovimientosContenido" style="margin-top: 20px;">
                    <!-- Los últimos movimientos serán mostrados aquí después de hacer la solicitud -->
                    <table>
                        <thead>
                            <tr>
                                <th>Tipo</th>
                                <th>Descripción</th>
                                <th>Cantidad</th>
                                <th>Fecha</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Aquí se mostrarán los movimientos -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="script.js"></script> <!-- El script principal -->
    <script src="script2.js"></script> <!-- El segundo script para actualizar los últimos movimientos -->
    <script src="script3.js"></script>

</body>

</html>
EOF