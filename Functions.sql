--Essa fun��o escalar recebe a data de nascimento de um cliente e retorna a idade em anos.

CREATE FUNCTION CalcularIdade (@dataNascimento DATE)
RETURN--1. Fun��o Escalar: Calcular a Idade do Cliente
S INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @dataNascimento, GETDATE());
END;

--Uso da Fun��o:

SELECT NomeCliente, dbo.CalcularIdade(Nascimento) AS Idade
FROM Cliente;

--Explica��o:
--Essa fun��o calcula a idade de cada cliente com base na data de nascimento e na data atual. 
--Retorna um valor inteiro representando a idade, �til para consultas que segmentam clientes por idade.



--2. Fun��o de Tabela Inline: M�dicos por Especialidade
--Esta fun��o de tabela inline retorna uma lista de m�dicos que atendem em uma especialidade espec�fica.

CREATE FUNCTION MedicosPorEspecialidade (@EspecialidadeID INT)
RETURNS TABLE
AS
RETURN (
    SELECT Medico.MedicoID, Medico.NomeMedico, Medico.CRM
    FROM Medico
    JOIN MedicoEspecialidade ON Medico.MedicoID = MedicoEspecialidade.MedicoID
    WHERE MedicoEspecialidade.EspecialidadeID = @EspecialidadeID
);

--Uso da Fun��o:

SELECT *
FROM dbo.MedicosPorEspecialidade(1); -- Exemplo para especialidade com ID 1

--Explica��o:
--Essa fun��o retorna uma tabela com os m�dicos que atuam em uma especialidade espec�fica, identificada pelo EspecialidadeID fornecido. 
--� �til para listar m�dicos que atendem em uma �rea de especialidade espec�fica, como "Dermatologia Infantil" ou "Acne".



--3. Fun��o de Tabela Multideclara��o: Consultas por Cliente
--Esta fun��o de tabela multideclara��o retorna uma tabela de consultas associadas a um cliente espec�fico.

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

--Uso da Fun��o:

SELECT *
FROM dbo.ConsultasPorCliente(3); -- Exemplo para cliente com ID 1

--Explica��o:
--Essa fun��o retorna uma tabela contendo todas as consultas de um cliente espec�fico, incluindo o nome do m�dico e a especialidade da consulta. 
--� �til para mostrar o hist�rico de atendimento de um cliente, detalhando consultas passadas e futuras.