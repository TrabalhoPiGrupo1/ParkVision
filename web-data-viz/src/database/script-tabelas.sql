-- Arquivo de apoio, caso você queira criar tabelas como as aqui criadas para a API funcionar.
-- Você precisa executar os comandos no banco de dados para criar as tabelas,
-- ter este arquivo aqui não significa que a tabela em seu BD estará como abaixo!

/*
comandos para mysql server
*/

CREATE DATABASE parkVision;

USE parkVision;


CREATE TABLE usuario(
id_usuario INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(100) NOT NULL,
cpf CHAR(11) NOT NULL,
email VARCHAR(100) NOT NULL,
senha VARCHAR(255) NOT NULL
);

