CREATE DATABASE parkVision;
USE parkVision;

-- TABELA STATUS_EMPRESA
CREATE TABLE Status_empresa (
id_status_empresa INT PRIMARY KEY AUTO_INCREMENT,
situacao VARCHAR(100) NOT NULL
);

-- TABELA EMPRESA
 CREATE TABLE Empresa (
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL,
dt_cadastro DATE DEFAULT (CURRENT_DATE),
codigo_validacao CHAR(5) NOT NULL,
fk_status_empresa INT,
    
CONSTRAINT fkStatusEmpresa 
	FOREIGN KEY (fk_status_empresa) REFERENCES Status_empresa(id_status_empresa)
);

-- TABELA FUNCIONARIO_USUARIO
CREATE TABLE Funcionario_usuario (
id_funcionario_usuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
cpf CHAR(11) NOT NULL,
email VARCHAR(100) NOT NULL,
usuario VARCHAR(100) NOT NULL,
senha VARCHAR(255) NOT NULL,
fk_empresa INT,

CONSTRAINT ckFkEmpresa 
	FOREIGN KEY (fk_empresa) REFERENCES Empresa(id_empresa)
);

-- TABELA ENDERECO
CREATE TABLE Endereco (
id_endereco INT PRIMARY KEY AUTO_INCREMENT,
logradouro VARCHAR(100) NOT NULL,
bairro VARCHAR(100) NOT NULL,
cidade VARCHAR(100) NOT NULL,
numero VARCHAR(20) NOT NULL,
CEP CHAR(8) NOT NULL
);


-- TABELA ESTACIONAMENTO
CREATE TABLE Estacionamento (
    id_estacionamento INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    dt_cadastro DATE DEFAULT (CURRENT_DATE),
    status_estacionamento VARCHAR(45),
    tarifa DECIMAL(5,2) NOT NULL,
    qtd_vagas INT NOT NULL,
    fk_endereco INT NOT NULL,
    fk_funcionario INT,
    
    CONSTRAINT chkTarifa 
		CHECK (tarifa > 0),
    CONSTRAINT ckFkEndereco 
		FOREIGN KEY (fk_endereco) REFERENCES Endereco(id_endereco),
	CONSTRAINT ckFkFuncionario 
		FOREIGN KEY (fk_funcionario) REFERENCES Funcionario_usuario(id_funcionario_usuario)
);

-- TABELA VAGA
CREATE TABLE Vaga(
    id_vaga INT PRIMARY KEY AUTO_INCREMENT,
    localizacao VARCHAR(5) NOT NULL,
    fk_estacionamento INT,
    
    CONSTRAINT ckFkEstacionamento
		FOREIGN KEY (fk_estacionamento) REFERENCES Estacionamento (id_estacionamento)
);

-- TABELA SENSOR_MEDIDA
CREATE TABLE Sensor_medida (
    id_sensor_medida INT PRIMARY KEY AUTO_INCREMENT,
    leitura_sensor TINYINT NOT NULL,
    dt_hora_leitura DATETIME DEFAULT CURRENT_TIMESTAMP,
    fk_vaga INT,
    
    CONSTRAINT ckFkVaga 
		FOREIGN KEY (fk_vaga) REFERENCES Vaga(id_vaga)
);

-- TABELA ALERTA
CREATE TABLE Alerta(
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    dt_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    descricao VARCHAR(100) NOT NULL,
    fk_sensor_medida INT,
    
    CONSTRAINT ckFkSensorMedida FOREIGN KEY (fk_sensor_medida) REFERENCES Sensor_medida(id_sensor_medida)
);


-- ======================================================================================================
--                                   INSERTS DE CADA TABELA
-- ======================================================================================================

-- STATUS EMPRESA
INSERT INTO Status_empresa (situacao) VALUES
('Verificado'),
('Não verificado');

-- EMPRESA
INSERT INTO Empresa (nome, cnpj, dt_cadastro, codigo_validacao, fk_status_empresa) VALUES
('Shopping Center Norte Ltda', '12345678000190', '2026-10-05', '12345', 1),
('Rede Park Mais S.A.', '98765432000110', '2026-06-09', '54321', 1),
('SPTestaciona Bem', '11222333000144', '2026-05-23', '09876', 2);

-- FUNCIONARIO
INSERT INTO Funcionario_usuario (nome, cpf, email, usuario, senha, fk_empresa) VALUES
('Giulia Ramos', '54200765888', 'giuliaramos@gmail.com', 'Giuliadmin','SPTech@123', 1),
('Luiza Chaves', '00780272811', 'luizachaves@gmail.com',' luizachaves', 'senhaF0rt#', 2),
('Felipe Mote', '33201765952', 'felipemote@gmail.com', 'felipegestor', 'B@nc0dedados', 2),
('Beatriz Aparecida', '64204765884', 'beatrizaparecida@gmail.com', 'biagerente', 'Spr1nt510', 3);

-- ENDERECO
INSERT INTO Endereco (logradouro, bairro, cidade, numero, CEP) VALUES
('Avenida Paulista', 'Bela Vista', 'São Paulo', '1578', '01310200'),
('Rua Oscar Freire', 'Cerqueira César', 'São Paulo', '900', '01426001'),
('Praça da Sé', 'Sé', 'São Paulo', 'S/N', '01001000'),
('Avenida Pedro Álvares Cabral', 'Vila Mariana', 'São Paulo', 'S/N', '04094050');

-- ESTACIONAMENTO
INSERT INTO Estacionamento (nome, dt_cadastro, status_estacionamento, tarifa, qtd_vagas, fk_endereco, fk_funcionario) VALUES
('Estacionamento Paulista Central', '2026-01-15', 'Ativo', 25.50, 120, 1, 1),
('Estapar Oscar Freire', '2026-02-10', 'Ativo', 30.00, 80, 2, 2),
('Park Sé Histórico', '2026-03-01', 'Ativo', 18.00, 50, 3, 4),
('Ibirapuera Park Vagas', '2026-04-12', 'Ativo', 20.00, 200, 4, 3);

-- VAGA
INSERT INTO Vaga (localizacao, fk_estacionamento) VALUES
('A01', 1),
('A02', 1),
('A03', 1),
('B01', 2),
('B02', 2),
('B03', 2),
('C01', 3),
('C02', 3),
('D01', 4),
('D02', 4);

-- SENSORMEDIDA (1 = ocupada, 0 = livre)
INSERT INTO Sensor_medida (leitura_sensor, fk_vaga) VALUES
(0, 1),
(1, 2),
(1, 4),
(0, 5),
(1, 9);

-- ALERTA
INSERT INTO Alerta (descricao, fk_sensor_medida) VALUES
('Estacionamento em alta', 1),
('Vaga ocupada por tempo excessivo', 2),
('Estacionamento lotado', 1),
('Estacionamento em período de vale', 3);


-- ======================================================================================================
--                                          SELECTS
-- ======================================================================================================

-- Empresa, seu estacionamentos e funcionário com acesso
SELECT 
    e.nome AS Empresa,
    e.cnpj,
    est.nome,
    f.nome as Funcionario,
    est.tarifa,
    est.status_estacionamento
FROM Empresa e
JOIN Funcionario_usuario f
	ON f.fk_empresa = e.id_empresa
JOIN Estacionamento est 
	ON est.fk_funcionario = f.id_funcionario_usuario;


-- Situação das vagas de um estacionamento específico
SELECT 
    est.nome AS 'Estacionamento',
    v.localizacao,
    CASE s.leitura_sensor WHEN 1 THEN 'Ocupada' ELSE 'Livre' END AS 'Ocupação das vagas'
FROM Vaga v
JOIN Sensor_medida s
	ON s.fk_vaga = v.id_vaga
JOIN Estacionamento est
	ON v.fk_estacionamento = est.id_estacionamento
		WHERE est.id_estacionamento = 1
		ORDER BY  v.localizacao;


-- Vagas ocupadas no momento
SELECT 
    est.nome,
    v.localizacao,
    s.leitura_sensor
FROM Estacionamento est
	JOIN Vaga v
		ON v.fk_estacionamento = est.id_estacionamento
	JOIN Sensor_medida s 
		ON s.fk_vaga = v.id_vaga
		WHERE s.leitura_sensor = 1; -- AND est.id_estacionamento = 2; -- Para selecionar um estacionamento específico

-- Alertas emitidos nos estacionamentos
SELECT 
    est.nome AS Estacionamento,
    v.localizacao AS Vaga,
    a.descricao AS Mensagem_Alerta,
    a.dt_alerta AS Data_Hora
FROM Alerta a
JOIN Sensor_medida s ON a.fk_sensor_medida = s.id_sensor_medida
JOIN Vaga v ON s.fk_vaga = v.id_vaga
JOIN Estacionamento est ON v.fk_estacionamento = est.id_estacionamento
-- WHERE est.id_estacionamento = 1; -- Especifica o estacionamento dos alertas
ORDER BY est.nome;

-- Faturamento baseado na tarifa cobrada
SELECT 
    e.nome AS Empresa,
    est.nome AS Estacionamento,
    est.tarifa AS Tarifa_Hora,
    est.qtd_vagas AS Total_Vagas,
    (est.tarifa * est.qtd_vagas) AS Receita_Max_Hora
FROM Estacionamento est
JOIN Funcionario_usuario f ON est.fk_funcionario = f.id_funcionario_usuario
JOIN Empresa e ON f.fk_empresa = e.id_empresa;


-- CRIAR NOVO USUÁRIO
CREATE USER 'usuarioInsert'@'localhost' IDENTIFIED BY 'parkVision@123'; -- Usuário novo
GRANT INSERT ON BANCODEDADADOS_PARKVISION.* TO 'usuarioInsert'@'localhost';
FLUSH PRIVILEGES;