USE master
--DROP DATABASE CrudCliente
CREATE DATABASE CrudCliente
USE CrudCliente 


CREATE TABLE cliente (
CPF				CHAR(11)			      NOT NULL, 
nome			VARCHAR (100)             NULL,
email			VARCHAR(200)			  NULL,
limiteCredito   DECIMAL(7,2)			  NULL,
dataNascimento  DATE               NULL
PRIMARY KEY (CPF)
)
GO

INSERT INTO cliente (CPF, nome, email, limiteCredito, dataNascimento) 
VALUES 
('12345678901', 'Fulano de Tal', 'fulano@example.com', 1000.00, '01-01-1990'),
('98765432109', 'Ciclano de Tal', 'ciclano@example.com', 1500.00, '15-05-1985');

CREATE PROCEDURE sp_validaCPF 
    @CPF CHAR(11),
    @valido BIT OUTPUT
AS
BEGIN
    DECLARE @primeiroDigito INT;
    DECLARE @segundoDigito INT;
    DECLARE @i INT;
    DECLARE @soma INT;
    DECLARE @resto INT;

    SET @valido = 0; -- Inicializa como inválido por padrão

    -- Verificação se o CPF contém apenas dígitos numéricos
    IF @CPF NOT LIKE '%[^0-9]%' AND @CPF NOT IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999')
    BEGIN
        -- Cálculo do primeiro dígito verificador
        SET @soma = 0;
        SET @i = 10;
        WHILE @i >= 2
        BEGIN
            SET @soma = @soma + (CAST(SUBSTRING(@CPF, 11 - @i, 1) AS INT) * @i);
            SET @i = @i - 1;
        END;
        SET @resto = @soma % 11;
        SET @primeiroDigito = IIF(@resto < 2, 0, 11 - @resto);

        -- Cálculo do segundo dígito verificador
        SET @soma = 0;
        SET @i = 11;
        SET @CPF = @CPF + CAST(@primeiroDigito AS NVARCHAR(1));
        WHILE @i >= 2
        BEGIN
            SET @soma = @soma + (CAST(SUBSTRING(@CPF, 12 - @i, 1) AS INT) * @i);
            SET @i = @i - 1;
        END;
        SET @resto = @soma % 11;
        SET @segundoDigito = IIF(@resto < 2, 0, 11 - @resto);

        -- Verificação dos dígitos verificadores
        IF LEN(@CPF) = 11 AND SUBSTRING(@CPF, 10, 1) = CAST(@primeiroDigito AS NVARCHAR(1)) AND SUBSTRING(@CPF, 11, 1) = CAST(@segundoDigito AS NVARCHAR(1))
        BEGIN
            SET @valido = 1; -- CPF válido
        END;
    END;
END;

CREATE PROCEDURE sp_iud_cliente (
    @acao CHAR(1), 
    @CPF CHAR(11), 
    @nome VARCHAR(100), 
    @email VARCHAR(200), 
    @limiteCredito DECIMAL(7,2), 
    @dataNascimento DATE, 
    @saida VARCHAR(100) OUTPUT
)
AS
BEGIN
    DECLARE @cpfValido BIT

    -- Validar CPF
    EXEC sp_validaCPF @CPF, @cpfValido OUTPUT

    IF (UPPER(@acao) = 'I')
    BEGIN
        -- Verificar se o CPF já está cadastrado
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE CPF = @CPF)
        BEGIN
            -- Inserir cliente
            IF @cpfValido = 1
            BEGIN
                INSERT INTO cliente VALUES (@CPF, @nome, @email,
                @limiteCredito, CONVERT(DATE, @dataNascimento, 103))
                SET @saida = 'Cliente inserido com sucesso'
            END
            ELSE
            BEGIN
                RAISERROR('CPF inválido', 16, 1)
            END
        END
        ELSE
        BEGIN
            RAISERROR('Cliente já cadastrado', 16, 1)
        END
    END
    ELSE IF (UPPER(@acao) = 'U')
    BEGIN
        -- Atualizar cliente
        IF @cpfValido = 1
        BEGIN
            UPDATE cliente SET nome = @nome, email = @email,
            limiteCredito = @limiteCredito, dataNascimento = CONVERT(DATE, @dataNascimento, 103)
            WHERE CPF = @CPF
            SET @saida = 'Cliente atualizado com sucesso'
        END
        ELSE
        BEGIN
            RAISERROR('CPF inválido', 16, 1)
        END
    END
    ELSE IF (UPPER(@acao) = 'D')
    BEGIN
        -- Excluir cliente
        DELETE FROM cliente WHERE CPF = @CPF
        SET @saida = 'Cliente excluído com sucesso'
    END
    ELSE
    BEGIN
        RAISERROR('Operação inválida', 16, 1)
    END
END

-- Teste
DECLARE @out1 VARCHAR(100)
EXEC sp_iud_cliente 'I', '87643128014', 'Teste 53', 'teste@example.com', 1000.00, '1990-01-01', @out1 OUTPUT
PRINT @out1

SELECT * FROM cliente