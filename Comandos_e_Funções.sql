--TRIGGERS
CREATE OR ALTER TRIGGER DeletarValorEspecifico
ON Especialidade
INSTEAD OF DELETE
AS
BEGIN
  IF EXISTS (SELECT 1 FROM Especialidade WHERE EspecialidadeID IN (1, 2, 3, 4, 5, 6))
  BEGIN
    PRINT'A exclusão de dados desse campo é proibida!'
    RETURN
  END
END; 

DELETE FROM Especialidade WHERE EspecialidadeID = 4

--------------------------------------------------------------------------------------------------------------------------

--PROCEDURES

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE TYPE = 'P' AND NAME = 'CancelarConsulta')
BEGIN
DROP PROCEDURE CancelarConsulta
END
GO

CREATE PROCEDURE CancelarConsulta
@consultaid INT
AS
UPDATE Consulta
SET Status = 'Cancelada'
WHERE ConsultaID = @consultaid;
GO

EXEC CancelarConsulta 6

--------------------------------------------------------------------------------------------------------------------------

--PROCEDURES

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE TYPE = 'P' AND NAME = 'ConcluirConsulta')
BEGIN
DROP PROCEDURE ConcluirConsulta
END
GO

CREATE PROCEDURE ConcluirConsulta
@consultaid INT
AS
UPDATE Consulta
SET Status = 'Concluida'
WHERE ConsultaID = @consultaid;
GO

EXEC ConcluirConsulta 6

--------------------------------------------------------------------------------------------------------------------------

--WINDOW FUNCTION

SELECT 
DISTINCT CAST(DataConsulta AS DATE) AS DataConsulta,
SUM(ValordaConsulta) OVER (PARTITION BY CAST(DataConsulta AS DATE) ORDER BY DataConsulta) AS FaturamentoDoDia
FROM Consulta
ORDER BY DataConsulta;

--------------------------------------------------------------------------------------------------------------------------

--CTE's

WITH Médico_Especialidades 
AS (
SELECT
Medico.NomeMedico,
Especialidade.NomeEspecialidade
FROM Medico
INNER JOIN MedicoEspecialidade
ON Medico.MedicoID = MedicoEspecialidade.MedicoID
INNER JOIN Especialidade
ON MedicoEspecialidade.EspecialidadeID = Especialidade.EspecialidadeID
)

SELECT
NomeMedico,
NomeEspecialidade
FROM Médico_Especialidades

--------------------------------------------------------------------------------------------------------------------------

--VIEWS

CREATE VIEW ConsultasOtto
AS
SELECT 
Medico.NomeMedico,
Consulta.DataConsulta,
Cliente.NomeCliente,
Especialidade.NomeEspecialidade
FROM Consulta
JOIN Cliente
ON Consulta.ClienteID = Cliente.ClienteID
JOIN Medico
ON Consulta.MedicoID = Medico.MedicoID
JOIN Especialidade
ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
WHERE Medico.MedicoID = 1

SELECT *
FROM ConsultasOtto
ORDER BY DataConsulta ASC

--------------------------------------------------------------------------------------------------------------------------

--VIEWS

CREATE VIEW ConsultasDeolane
AS
SELECT 
Medico.NomeMedico,
Consulta.DataConsulta,
Cliente.NomeCliente,
Especialidade.NomeEspecialidade
FROM Consulta
JOIN Cliente
ON Consulta.ClienteID = Cliente.ClienteID
JOIN Medico
ON Consulta.MedicoID = Medico.MedicoID
JOIN Especialidade
ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
WHERE Medico.MedicoID = 2

SELECT *
FROM ConsultasDeolane
ORDER BY DataConsulta ASC

--------------------------------------------------------------------------------------------------------------------------

--VIEWS

CREATE VIEW ConsultasRaquel
AS
SELECT 
Medico.NomeMedico,
Consulta.DataConsulta,
Cliente.NomeCliente,
Especialidade.NomeEspecialidade
FROM Consulta
JOIN Cliente
ON Consulta.ClienteID = Cliente.ClienteID
JOIN Medico
ON Consulta.MedicoID = Medico.MedicoID
JOIN Especialidade
ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
WHERE Medico.MedicoID = 3

SELECT *
FROM ConsultasRaquel
ORDER BY DataConsulta ASC

--------------------------------------------------------------------------------------------------------------------------

--VIEWS

CREATE VIEW ConsultasClienteID1 
AS
SELECT 
Cliente.NomeCliente,
Medico.NomeMedico,
Consulta.DataConsulta,
Especialidade.NomeEspecialidade
FROM Consulta
JOIN Cliente
ON Consulta.ClienteID = Cliente.ClienteID
JOIN Medico
ON Consulta.MedicoID = Medico.MedicoID
JOIN Especialidade
ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
WHERE Cliente.ClienteID = 1

SELECT *
FROM ConsultasClienteID1 
ORDER BY DataConsulta ASC

--------------------------------------------------------------------------------------------------------------------------

--VIEWS

CREATE VIEW ConsultasClienteID2 
AS
SELECT 
Cliente.NomeCliente,
Medico.NomeMedico,
Consulta.DataConsulta,
Especialidade.NomeEspecialidade
FROM Consulta
JOIN Cliente
ON Consulta.ClienteID = Cliente.ClienteID
JOIN Medico
ON Consulta.MedicoID = Medico.MedicoID
JOIN Especialidade
ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
WHERE Cliente.ClienteID = 2

SELECT *
FROM ConsultasClienteID2
ORDER BY DataConsulta ASC

--------------------------------------------------------------------------------------------------------------------------

--VIEWS

CREATE VIEW ConsultasClienteID3
AS
SELECT 
Cliente.NomeCliente,
Medico.NomeMedico,
Consulta.DataConsulta,
Especialidade.NomeEspecialidade
FROM Consulta
JOIN Cliente
ON Consulta.ClienteID = Cliente.ClienteID
JOIN Medico
ON Consulta.MedicoID = Medico.MedicoID
JOIN Especialidade
ON Consulta.EspecialidadeID = Especialidade.EspecialidadeID
WHERE Cliente.ClienteID = 3

SELECT *
FROM ConsultasClienteID3
ORDER BY DataConsulta ASC

--------------------------------------------------------------------------------------------------------------------------

--LOOP's

DECLARE @ClienteID INT;
DECLARE @Nome NVARCHAR(100);
DECLARE @contador INT = 1;
DECLARE @totalCliente INT;

-- Contar o total de pacientes sem consultas nos últimos 12 meses
SELECT @totalCliente = COUNT(*)
FROM Cliente
WHERE NOT EXISTS (
SELECT 1
FROM Consulta
WHERE Consulta.ClienteID = Cliente.ClienteID AND Consulta.DataConsulta >= DATEADD(MONTH,-12, GETDATE())
);

WHILE @contador <= @totalCliente
BEGIN

SELECT
@ClienteID = ClienteID,
@Nome = NomeCliente
FROM (
SELECT Cliente.ClienteID, Cliente.NomeCliente,
ROW_NUMBER() OVER (ORDER BY Cliente.NomeCliente) AS RowNum
FROM Cliente
WHERE NOT EXISTS (
SELECT 1
FROM Consulta
WHERE Consulta.ClienteID = Cliente.ClienteID AND Consulta.DataConsulta  >= DATEADD(MONTH, -12, GETDATE()) )) AS T
WHERE RowNum = @contador;

PRINT 'Paciente sem consultas nos últimos 2 meses: ' + @Nome ;
SET @contador = @contador + 1;
END;

--------------------------------------------------------------------------------------------------------------------------

--SUBQUERY

SELECT NomeCliente
FROM Cliente
WHERE ClienteID IN (
SELECT ClienteID
FROM Consulta
WHERE EspecialidadeID = (
SELECT EspecialidadeID
FROM Especialidade
WHERE NomeEspecialidade = 'Acne')
);