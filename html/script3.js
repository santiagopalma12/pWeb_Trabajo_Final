// Función para crear el gráfico de evolución del saldo
function crearGraficoSaldo(movimientos) {
    const ctx = document.getElementById('saldoChart').getContext('2d');
    
    // Preparar los datos del gráfico (fechas y saldos acumulados)
    const fechas = movimientos.map(mov => mov.fecha);
    const saldos = movimientos.map(mov => parseFloat(mov.saldo));

    // Crear el gráfico de línea
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: fechas,
            datasets: [{
                label: 'Saldo',
                data: saldos,
                borderColor: '#007bff',
                backgroundColor: 'rgba(0, 123, 255, 0.1)',
                borderWidth: 2,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Fecha'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Saldo'
                    },
                    beginAtZero: false
                }
            }
        }
    });
}

// Función para obtener los últimos movimientos y actualizar el gráfico
function obtenerUltimosMovimientos() {
    $.get("verUltimosMovimientos.pl", function(response) {
        if (response.success) {
            // Crear el gráfico con los movimientos recibidos
            crearGraficoSaldo(response.movimientos);
        } else {
            console.error("Error al obtener los movimientos.");
        }
    });
}

// Llamar a la función al cargar la página
window.onload = obtenerUltimosMovimientos;
