$(document).ready(function () {
    // Mostrar el saldo automáticamente al cargar la página
    $.getJSON('verSaldo.pl', function (response) {
        if (response.success) {
            $('#saldoContenido').html(`<p><strong>Saldo Actual:</strong> ${response.saldo}</p>`);
        } else {
            $('#saldoContenido').html(`<p>Error: ${response.message}</p>`);
        }
    }).fail(function () {
        $('#saldoContenido').html('<p>Error al cargar el saldo.</p>');
    });

    // Registrar transacción usando AJAX
    $('#submitAJAXInsertar').on('click', function () {
        $.post('myScriptAjax.pl', $('#formInsertar').serialize(), function (response) {
            $('#respInsertar').removeClass('alert-danger').addClass('alert-success').text(response.message).show();

            // Actualizar el saldo automáticamente después de registrar una transacción
            $.getJSON('verSaldo.pl', function (response) {
                if (response.success) {
                    $('#saldoContenido').html(`<p><strong>Saldo Actual:</strong> ${response.saldo}</p>`);
                } else {
                    $('#saldoContenido').html(`<p>Error: ${response.message}</p>`);
                }
            });
        }).fail(function () {
            $('#respInsertar').removeClass('alert-success').addClass('alert-danger').text('Error al registrar la transacción.').show();
        });
    });
});
