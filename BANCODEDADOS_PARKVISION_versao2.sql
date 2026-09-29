CREATE DATABASE parkVision;
USE parkVision;

-- 1. TABELA CLIENTE (Sem FK)
CREATE TABLE cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    statusCliente VARCHAR(20),
    CONSTRAINT chkStatus CHECK (statusCliente IN ('ativo', 'inativo')),
    dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    cnpj CHAR(14) UNIQUE NOT NULL
);

-- 2. TABELA SENSORMEDIDA (Anteriormente medidaSensor / Sem FK)
CREATE TABLE sensorMedida (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    leituraSensor BOOLEAN NOT NULL,
    dt_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABELA ESTACIONAMENTO (Depende de cliente)
CREATE TABLE estacionamento (
    idEstacionamento INT PRIMARY KEY AUTO_INCREMENT,
    nomeEstacionamento VARCHAR(120) NOT NULL,
    emailEstacionamento VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(30) NOT NULL,
    statusEstacionamento VARCHAR(20),
    tarifaHora DECIMAL(5,2) NOT NULL,
    CONSTRAINT chkTarifa CHECK (tarifaHora > 0),
    CONSTRAINT chkStatusEstacionamento CHECK (statusEstacionamento IN ('ativo', 'inativo')),
    dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    qtdVagas INT NOT NULL,
    fk_cliente INT,
    CONSTRAINT ckfk_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente (idCliente)
);

-- 4. TABELA VAGA (Depende de sensorMedida e estacionamento)
CREATE TABLE vaga (
    idVaga INT PRIMARY KEY AUTO_INCREMENT,
    coordenadaVaga VARCHAR(20) NOT NULL, -- Ex: "C5"
    fk_sensor INT, 
    fk_estacionamento INT,
    CONSTRAINT ckfk_sensor FOREIGN KEY (fk_sensor) REFERENCES sensorMedida (idSensor),
    CONSTRAINT ckfk_estacionamento FOREIGN KEY (fk_estacionamento) REFERENCES estacionamento (idEstacionamento)
);

-- 5. TABELA HISTDADOS (Depende de vaga)
CREATE TABLE histDados (
    idDado INT PRIMARY KEY AUTO_INCREMENT,
    dataHoraInicio DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    dataHoraFim DATETIME,
    tempoPermanencia TIME AS (TIMEDIFF(dataHoraFim, dataHoraInicio)),
    fk_vaga INT,
    CONSTRAINT ckfk_vaga FOREIGN KEY (fk_vaga) REFERENCES vaga (idVaga)
);

-- 6. TABELA ALERTA (Depende de estacionamento)
CREATE TABLE alerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    mensagem VARCHAR(200),
    dataAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    fk_estacionamento2 INT,
    CONSTRAINT ckfk_estacionamento2 FOREIGN KEY (fk_estacionamento2) REFERENCES estacionamento (idEstacionamento)
);


-- ======================================================================================================
--                                   INSERTS DE CADA TABELA
-- ======================================================================================================

-- CLIENTE
INSERT INTO cliente (nome, statusCliente, cnpj) VALUES
('Shopping Center Norte Ltda', 'ativo', '12345678000190'),
('Rede Park Mais S.A.', 'ativo', '98765432000110'),
('Estaciona Fácil ME', 'inativo', '11222333000144');

-- SENSORMEDIDA (1 = ocupada, 0 = livre)
INSERT INTO sensorMedida (leituraSensor) VALUES
(1), (0), (1), (0),   -- sensores 1 a 4
(1), (1), (0),        -- sensores 5 a 7
(0);                 -- sensor 8

-- ESTACIONAMENTO
INSERT INTO estacionamento (nomeEstacionamento, emailEstacionamento, telefone, statusEstacionamento, tarifaHora, qtdVagas, fk_cliente) VALUES
('Estacionamento Norte - Bloco A', 'blocoa@centernorte.com', '(11) 4002-8922', 'ativo', 12.50, 4, 1),
('Park Mais Paulista', 'paulista@parkmais.com', '(11) 3333-4444', 'ativo', 18.00, 3, 2),
('Estaciona Fácil Centro', 'centro@estacionafacil.com', '(11) 2222-1111', 'inativo', 8.00, 1, 3);

-- VAGA
INSERT INTO vaga (coordenadaVaga, fk_sensor, fk_estacionamento) VALUES
('A1', 1, 1),
('A2', 2, 1),
('B1', 3, 1),
('B2', 4, 1),
('C1', 5, 2),
('C2', 6, 2),
('C3', 7, 2),
('D1', 8, 3);

-- HISTDADOS (dataHoraFim NULL = veículo ainda na vaga)
INSERT INTO histDados (dataHoraInicio, dataHoraFim, fk_vaga) VALUES
('2026-09-28 08:00:00', '2026-09-28 10:30:00', 1),
('2026-09-28 09:15:00', '2026-09-28 09:45:00', 2),
('2026-09-28 11:00:00', NULL, 3),
('2026-09-28 07:30:00', '2026-09-28 12:00:00', 5),
('2026-09-28 13:00:00', NULL, 6),
('2026-09-27 14:00:00', '2026-09-27 20:00:00', 7);

-- ALERTA
INSERT INTO alerta (mensagem, fk_estacionamento2) VALUES
('Estacionamento quase lotado', 1),
('Sensor sem resposta', 2),
('Vaga ocupada por tempo excessivo', 2),
('Estacionamento lotado', 1);


-- ======================================================================================================
--                                          SELECTS
-- ======================================================================================================

-- 1 - Clientes e seus estacionamentos
SELECT 
    c.nome AS cliente,
    c.cnpj,
    e.nomeEstacionamento,
    e.tarifaHora,
    e.statusEstacionamento
FROM cliente c
JOIN estacionamento e ON e.fk_cliente = c.idCliente;

-- 2 - Vagas com estacionamento e situação do sensor
SELECT 
    e.nomeEstacionamento,
    v.coordenadaVaga,
    CASE s.leituraSensor WHEN 1 THEN 'Ocupada' ELSE 'Livre' END AS situacao
FROM vaga v
JOIN sensorMedida s ON s.idSensor = v.fk_sensor
JOIN estacionamento e ON e.idEstacionamento = v.fk_estacionamento
ORDER BY e.nomeEstacionamento, v.coordenadaVaga;

-- 3 - Histórico completo: cliente - estacionamento - vaga - permanência
SELECT 
    c.nome AS cliente,
    e.nomeEstacionamento,
    v.coordenadaVaga,
    h.dataHoraInicio,
    h.dataHoraFim,
    h.tempoPermanencia
FROM histDados h
JOIN vaga v ON v.idVaga = h.fk_vaga
JOIN estacionamento e ON e.idEstacionamento = v.fk_estacionamento
JOIN cliente c ON c.idCliente = e.fk_cliente
ORDER BY h.dataHoraInicio;

-- 4 - Alertas por estacionamento e cliente
SELECT 
    c.nome AS cliente,
    e.nomeEstacionamento,
    a.mensagem,
    a.dataAlerta
FROM alerta a
JOIN estacionamento e ON e.idEstacionamento = a.fk_estacionamento2
JOIN cliente c ON c.idCliente = e.fk_cliente
ORDER BY a.dataAlerta DESC; 

-- 5 - Apenas as vagas ocupadas no momento
SELECT 
    e.nomeEstacionamento,
    v.coordenadaVaga,
    s.leituraSensor
FROM estacionamento e
JOIN vaga v ON v.fk_estacionamento = e.idEstacionamento
JOIN sensorMedida s ON s.idSensor = v.fk_sensor
WHERE s.leituraSensor = 1;

-- 6 - Estacionamentos sem nenhum alerta 
SELECT e.nomeEstacionamento, e.statusEstacionamento
FROM estacionamento e
LEFT JOIN alerta a ON a.fk_estacionamento2 = e.idEstacionamento
WHERE a.idAlerta IS NULL;

-- 7 - Todos os estacionamentos com seus alertas, mesmo os sem alerta
SELECT 
    e.nomeEstacionamento,
    a.mensagem,
    a.dataAlerta
FROM estacionamento e
LEFT JOIN alerta a ON a.fk_estacionamento2 = e.idEstacionamento
ORDER BY e.nomeEstacionamento, a.dataAlerta;

-- CRIAR NOVO USUÁRIO
CREATE USER 'usuarioInsert'@'localhost' IDENTIFIED BY 'parkVision@123'; -- Usuário novo
GRANT INSERT ON BANCODEDADADOS_PARKVISION.* TO 'usuarioInsert'@'localhost';
FLUSH PRIVILEGES;