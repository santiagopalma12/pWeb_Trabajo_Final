-- Crea la base de datos si no existe
CREATE DATABASE IF NOT EXISTS gestor_finanzas;

-- Usa la base de datos creada
USE gestor_finanzas;

-- Crea la tabla de transacciones
CREATE TABLE IF NOT EXISTS transacciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo VARCHAR(50),
  cantidad DECIMAL(10, 2),
  descripcion TEXT,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
