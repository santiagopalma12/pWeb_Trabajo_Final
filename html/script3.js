// Función para crear el gráfico de evolución del saldo
function crearGraficoSaldo(movimientos) {
    const ctx = document.getElementById('saldoChart').getContext('2d');
    
    // Preparar los datos del gráfico (fechas y saldos acumulados)
    const fechas = movimientos.map(mov => mov.fecha);
    const saldos = movimientos.map(mov => parseFloat(mov.saldo));

    // Crear o actualizar el gráfico de línea
    if (window.chart) {
        // Si ya existe el gráfico, actualízalo
        window.chart.data.labels = fechas;
        window.chart.data.datasets[0].data = saldos;
        window.chart.update();
    } else {
        // Si no existe el gráfico, crea uno nuevo
        window.chart = new Chart(ctx, {
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
}

// Función para obtener los últimos movimientos y actualizar el gráfico
function obtenerUltimosMovimientos() {
    $.get("verUltimosMovimientos.pl", function(response) {
        if (response.success) {
            // Crear o actualizar el gráfico con los movimientos recibidos
            crearGraficoSaldo(response.movimientos);
        } else {
            console.error("Error al obtener los movimientos.");
        }
    });
}

// Llamar a la función de actualización cada 5 segundos (5000 ms)
setInterval(obtenerUltimosMovimientos, 2000);

// Llamar a la función al cargar la página
window.onload = obtenerUltimosMovimientos;
