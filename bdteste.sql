-- 1. Cria o banco de dados (caso não exista)
CREATE DATABASE IF NOT EXISTS estacionamento;

-- 2. Seleciona o banco para uso
USE estacionamento;

-- 3. Cria a tabela de medidas
CREATE TABLE IF NOT EXISTS medida (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_digital BOOLEAN NOT NULL,
    dt_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

select * from medida;