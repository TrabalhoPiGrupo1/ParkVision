-- Arquivo de apoio, caso você queira criar tabelas como as aqui criadas para a API funcionar.
-- Você precisa executar os comandos no banco de dados para criar as tabelas,
-- ter este arquivo aqui não significa que a tabela em seu BD estará como abaixo!

/*
comandos para mysql server
*/

CREATE DATABASE parkvision;
USE parkvision;

-- 1. Tabela endereco
CREATE TABLE endereco (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(100),
    bairro VARCHAR(100),
    CEP CHAR(8),
    numero VARCHAR(20),
    cidade VARCHAR(100)
);

-- 2. Tabela Empresa
CREATE TABLE Empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome_fantasia VARCHAR(100),
    cnpj CHAR(14),
    dt_cadastro DATE,
    codigo_validacao CHAR(5),
    razao_social VARCHAR(100)
);

-- 3. Tabela cargos
CREATE TABLE cargos (
    id_cargo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45)
);

-- 4. Tabela Usuario
CREATE TABLE Usuario (
    id_funcionario_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cpf CHAR(11),
    email VARCHAR(100),
    senha VARCHAR(255),
    fk_empresa INT,
    fk_cargo INT,
    CONSTRAINT fk_usuario_empresa FOREIGN KEY (fk_empresa) REFERENCES Empresa(id_empresa),
    CONSTRAINT fk_usuario_cargo FOREIGN KEY (fk_cargo) REFERENCES cargos(id_cargo)
);

-- 5. Tabela Estacionamento
CREATE TABLE Estacionamento (
    id_estacionamento INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    status_estacionamento VARCHAR(45),
    dt_cadastro DATE,
    tarifa DECIMAL(5,2),
    fk_endereco INT,
    fk_empresa INT,
    CONSTRAINT fk_estacionamento_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco),
    CONSTRAINT fk_estacionamento_empresa FOREIGN KEY (fk_empresa) REFERENCES Empresa(id_empresa)
);

-- 6. Tabela Vaga
CREATE TABLE Vaga (
    id_vaga INT PRIMARY KEY AUTO_INCREMENT,
    bloco VARCHAR(5),
    numero INT,
    fk_estacionamento INT,
    CONSTRAINT fk_vaga_estacionamento FOREIGN KEY (fk_estacionamento) REFERENCES Estacionamento(id_estacionamento)
);

-- 7. Tabela Sensor_medida
CREATE TABLE Sensor_medida (
    id_sensor_medida INT PRIMARY KEY AUTO_INCREMENT,
    leitura_sensor TINYINT,
    dt_hora_leitura DATETIME,
    fk_vaga INT,
    CONSTRAINT fk_sensor_vaga FOREIGN KEY (fk_vaga) REFERENCES Vaga(id_vaga)
);

-- 8. Tabela Alerta
CREATE TABLE Alerta (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    dt_alerta DATETIME,
    descricao VARCHAR(150),
    fk_sensor_medida INT,
    CONSTRAINT fk_alerta_sensor FOREIGN KEY (fk_sensor_medida) REFERENCES Sensor_medida(id_sensor_medida)
);

INSERT INTO Empresa (codigo_validacao, razao_social) VALUES
('5EH20', 'Empresa 1'),
('3KS95', 'Empresa 2');

INSERT INTO cargos (nome) VALUES
('Gerente'),
('Supervisor'),
('Analista');