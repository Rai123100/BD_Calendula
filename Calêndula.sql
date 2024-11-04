--CRIANDO O BANCO DE DADOS

CREATE DATABASE Calêndula;

------------------------------------------------------------------

--CRIANDO A TABELA DE ESPECIALIDADES

USE Calêndula;

CREATE TABLE Especialidade (
    EspecialidadeID INT PRIMARY KEY,
    NomeEspecialidade VARCHAR(255) NOT NULL
);

INSERT INTO Especialidade (EspecialidadeID, NomeEspecialidade)
VALUES
    (1, 'Acne'),
    (2, 'Rosácea'),
    (3, 'Dermatologia Infantil'),
    (4, 'Micose'),
    (5, 'Hiperidrose'),
    (6, 'Melasma'),
    (7, 'Queda de cabelo');

------------------------------------------------------------------

--CRIANDO A TABELA MEDICO

CREATE TABLE Medico (
	MedicoID INT PRIMARY KEY,
	CRM VARCHAR(10) NOT NULL,
	CPF VARCHAR(14) NOT NULL,
	RG VARCHAR(14) NOT NULL,
	NomeMedico VARCHAR(50) NOT NULL,
	Email VARCHAR(100) NOT NULL,
	Nascimento DATE NOT NULL,
	Genero VARCHAR(20) NOT NULL,
	Celular VARCHAR(18) NOT NULL,
	CEP VARCHAR(9) NOT NULL,
	Endereco VARCHAR(100) NOT NULL,
	Salario FLOAT NOT NULL
);

INSERT INTO Medico (MedicoID, CRM, CPF, RG, NomeMedico, Email, Nascimento, Genero, Celular, CEP, Endereco, Salario)
VALUES
    (1, '11111111', '111.111.111-1', '11.111.112-1', 'Dr. Otto Octavius', 'otto@gmail.com', '14/06/1997', 'M', '55 (11) 11111-1111', '11111-111', 'Rua Ameixa, 617', '6000'),
    (2, '22222222', '111.111.111-2', '11.111.112-2', 'Dra. Deolane Silva', 'deolane@gmail.com', '17/09/1998', 'F', '55 (11) 11111-1112', '22222-222', 'Rua Ameixa, 618', '3000'),
    (3, '11111111', '111.111.111-3', '11.111.112-3', 'Dra. Raquel Ruy Barbosa', 'raquel@gmail.com', '24/10/2000', 'F', '55 (11) 11111-1113', '33333-333', 'Rua Ameixa, 619', '7000');

------------------------------------------------------------------
--CRIANDO A TABELA CONSULTA

CREATE TABLE Consulta (
	ConsultaID INT PRIMARY KEY,
	NumerodaConsulta INT NOT NULL,
	DataConsulta DATETIME NOT NULL,
	MedicoID INT,
	EspecialidadeID INT,
	ClienteID INT,
	ValordaConsulta FLOAT
	FOREIGN KEY (MedicoID) REFERENCES Medico(MedicoID),
	FOREIGN KEY (EspecialidadeID) REFERENCES Especialidade(EspecialidadeID),
	FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
)

INSERT INTO Consulta (ConsultaID, NumerodaConsulta, DataConsulta, MedicoID, EspecialidadeID, ClienteID, ValordaConsulta)
VALUES
	(1, 101, '2024-24-08', 3, 6, 1, '600'),
	(2, 102, '2024-10-08', 1, 4, 2, '400'),
	(3, 103, '2024-25-08', 3, 3, 3, '300'),
	(4, 104, '2024-10-09', 2, 2, 2, '200'),
	(5, 105, '2024-13-09', 2, 1, 1, '100'),
	(6, 106, '2024-12-08', 1, 7, 3, '700');

------------------------------------------------------------------

--CRIANDO A TABELA CLIENTE

CREATE TABLE Cliente (
	ClienteID INT PRIMARY KEY,
	CPF VARCHAR (12) NOT NULL,
	NomeCliente VARCHAR (100) NOT NULL,
	Email VARCHAR (100) NOT NULL,
	RG VARCHAR (12) NOT NULL,
	Nascimento DATE NOT NULL,
	Genero VARCHAR (20) NOT NULL,
	Endereco VARCHAR (100) NOT NULL,
	Telefone VARCHAR (50)
);


INSERT INTO Cliente (ClienteID, CPF, NomeCliente, Email, RG, Nascimento, Genero, Endereco, Telefone)
VALUES
(1, '111111111-10', 'Rafaela Botelho', 'aluno103devt.rafaelabotelho@gmail.com', '11.111.111-1', '2005-05-17', 'F', 'Rua Batata, 111, São Paulo - SP', '55 (11) 99999-9999'),
(2, '111111111-20', 'Bruna Barboza', 'aluno103devt.brunabarboza@gmail.com', '11.111.111-2', '2007-12-31', 'F', 'Rua Chiclete, 222, São Paulo - SP', '55 (11) 88888-8888'),
(3, '111111111-30', 'Arthur Américo', 'aluno103devt.arthuramerico@gmail.com', '11.111.111-3', '2007-06-12', 'M', 'Rua Queijinho, 333, Pindamonhangaba - SP', '55 (11) 77777-7777; 55 (11) 66666-6666');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CRIANDO A TABELA MEDICOESPECIALIDADE

CREATE TABLE MedicoEspecialidade (
	MedicoEspecialidadeID INT PRIMARY KEY,
    EspecialidadeID INT,
	MedicoID INT
	FOREIGN KEY (EspecialidadeID) REFERENCES Especialidade(EspecialidadeID),
	FOREIGN KEY (MedicoID) REFERENCES Medico(MedicoID)
);

INSERT INTO MedicoEspecialidade (MedicoEspecialidadeID, EspecialidadeID, MedicoID)
VALUES
	(1, '1', '2'),
	(2, '2', '2'),
	(3, '3', '3'),
	(4, '4', '1'),
	(5, '5', '1'),
	(6, '6', '3'),
	(7, '7', '1'),
	(8, '1', '3');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--1. Função Escalar: Calcular a Idade do Cliente
--Essa função escalar recebe a data de nascimento de um cliente e retorna a idade em anos.

CREATE FUNCTION CalcularIdade (@dataNascimento DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @dataNascimento, GETDATE());
END;

--Uso da Função:

SELECT NomeCliente, dbo.CalcularIdade(Nascimento) AS Idade
FROM Cliente;

--Explicação:
--Essa função calcula a idade de cada cliente com base na data de nascimento e na data atual. 
--Retorna um valor inteiro representando a idade, útil para consultas que segmentam clientes por idade.



--2. Função de Tabela Inline: Médicos por Especialidade
--Esta função de tabela inline retorna uma lista de médicos que atendem em uma especialidade específica.

CREATE FUNCTION MedicosPorEspecialidade (@EspecialidadeID INT)
RETURNS TABLE
AS
RETURN (
    SELECT Medico.MedicoID, Medico.NomeMedico, Medico.CRM
    FROM Medico
    JOIN MedicoEspecialidade ON Medico.MedicoID = MedicoEspecialidade.MedicoID
    WHERE MedicoEspecialidade.EspecialidadeID = @EspecialidadeID
);

--Uso da Função:

SELECT *
FROM dbo.MedicosPorEspecialidade(1); -- Exemplo para especialidade com ID 1

--Explicação:
--Essa função retorna uma tabela com os médicos que atuam em uma especialidade específica, identificada pelo EspecialidadeID fornecido. 
--É útil para listar médicos que atendem em uma área de especialidade específica, como "Dermatologia Infantil" ou "Acne".



--3. Função de Tabela Multideclaração: Consultas por Cliente
--Esta função de tabela multideclaração retorna uma tabela de consultas associadas a um cliente específico.

CREATE FUNCTION ConsultasPorCliente (@ClienteID INT)
RETURNS @TabelaConsultas TABLE (
    ConsultaID INT,
    DataConsulta DATETIME,
    Especialidade VARCHAR(255),
    NomeMedico VARCHAR(50)
)
AS
BEGIN
    INSERT INTO @TabelaConsultas
    SELECT Consulta.ConsultaID, Consulta.DataConsulta, Especialidade.NomeEspecialidade, Medico.NomeMedico
    FROM Consulta
    JOIN Especialidade ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
    JOIN Medico ON Consulta.MedicoID = Medico.MedicoID
    WHERE Consulta.ClienteID = @ClienteID;

    RETURN;
END;

--Uso da Função:

SELECT *
FROM dbo.ConsultasPorCliente(3); -- Exemplo para cliente com ID 1

--Explicação:
--Essa função retorna uma tabela contendo todas as consultas de um cliente específico, incluindo o nome do médico e a especialidade da consulta. 
--É útil para mostrar o histórico de atendimento de um cliente, detalhando consultas passadas e futuras.