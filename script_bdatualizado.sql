CREATE DATABASE IF NOT EXISTS parkvision;
USE parkvision;

-- 1. Tabela endereco
CREATE TABLE endereco (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(100),
    bairro VARCHAR(100),
    CEP CHAR(9),
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

INSERT INTO endereco (logradouro, bairro, CEP, numero, cidade)
VALUES ('Rua Teste', 'Centro', '01000000', '100', 'São Paulo');

INSERT INTO Empresa (nome_fantasia, cnpj, dt_cadastro, codigo_validacao, razao_social)
VALUES ('Empresa Teste', '12345678000199', CURDATE(), 'ABC12', 'Empresa Teste LTDA');

INSERT INTO Estacionamento (nome, status_estacionamento, dt_cadastro, tarifa, fk_endereco, fk_empresa)
VALUES ('Teste', 'ativo', CURDATE(), 10.00, 1, 1);

INSERT INTO Vaga (bloco, numero, fk_estacionamento)
VALUES ('A', 1, 1), ('A', 2, 1);

INSERT INTO Sensor_medida (leitura_sensor, dt_hora_leitura, fk_vaga)
VALUES (1, NOW(), 1), (0, NOW(), 2);

SELECT v.id_vaga, v.bloco, v.numero,
       sm.leitura_sensor, sm.dt_hora_leitura
FROM Vaga v
JOIN Sensor_medida sm ON sm.fk_vaga = v.id_vaga
WHERE v.fk_estacionamento = 1
  AND sm.id_sensor_medida = (
    SELECT MAX(id_sensor_medida)
    FROM Sensor_medida
    WHERE fk_vaga = v.id_vaga
  )
ORDER BY v.bloco, v.numero;

select * from Estacionamento;

select * from Usuario; 

ALTER TABLE endereco
MODIFY COLUMN CEP VARCHAR(9);