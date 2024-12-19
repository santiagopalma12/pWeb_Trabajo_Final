CREATE DATABASE IF NOT EXISTS usuarios;
USE usuarios;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Agregar algunos usuarios de ejemplo
INSERT INTO users (username, password) VALUES
('usuario1', 'contraseña1'),
('usuario2', 'contraseña2');
