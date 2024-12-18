$(document).ready(function() {
    // Función para actualizar los últimos movimientos automáticamente al cargar la página
    function cargarUltimosMovimientos() {
        $.getJSON('verUltimosMovimientos.pl', function(response) {
            if (response.success) {
                let movimientosHTML = '<table border="1"><thead><tr><th>Tipo</th><th>Descripción</th><th>Cantidad</th><th>Fecha</th></tr></thead><tbody>';
                response.movimientos.forEach(function(movimiento) {
                    movimientosHTML += `<tr>
                        <td>${movimiento.tipo}</td>
                        <td>${movimiento.descripcion}</td>
                        <td>${movimiento.cantidad}</td>
                        <td>${movimiento.fecha}</td>
                    </tr>`;
                });
                movimientosHTML += '</tbody></table>';
                $('#ultimosMovimientosContenido').html(movimientosHTML);
            } else {
                $('#ultimosMovimientosContenido').html('<p>Error al cargar los últimos movimientos.</p>');
            }
        }).fail(function() {
            $('#ultimosMovimientosContenido').html('<p>Error al cargar los últimos movimientos.</p>');
        });
    }

    // Llamar a la función para cargar los últimos movimientos al cargar la página
    cargarUltimosMovimientos();

    // Registrar transacción usando AJAX y luego actualizar los últimos movimientos
    $('#submitAJAXInsertar').on('click', function() {
        $.post('myScriptAjax.pl', $('#formInsertar').serialize(), function(response) {
            $('#respInsertar').removeClass("alert-danger").addClass("alert-success").text(response.message).show();

            // Actualizar los últimos movimientos automáticamente después de registrar una transacción
            cargarUltimosMovimientos();
        }).fail(function() {
            $('#respInsertar').removeClass("alert-success").addClass("alert-danger").text("Error al registrar la transacción.").show();
        });
    });
});
