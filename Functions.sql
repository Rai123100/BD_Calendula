--Essa função escalar recebe a data de nascimento de um cliente e retorna a idade em anos.

CREATE FUNCTION CalcularIdade (@dataNascimento DATE)
RETURN--1. Função Escalar: Calcular a Idade do Cliente
S INT
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