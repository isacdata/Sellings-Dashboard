-- =============================================
-- ANALISES INICIAIS: CONTAGENS E TOP 1000
-- =============================================

-- Contagem total de registros nas tabelas
SELECT 'f_financeiro' AS Tabela, COUNT(*) AS Contagem FROM dbo.f_financeiro
UNION ALL
SELECT 'f_vendas' AS Tabela, COUNT(*) FROM dbo.f_vendas;

-- Contagem de clientes, vendedores e profissões únicos
SELECT 
    (SELECT COUNT(DISTINCT ID_Cliente) FROM dbo.f_vendas) AS ClientesUnicos,
    (SELECT COUNT(DISTINCT NomeVendedor) FROM dbo.f_vendas) AS VendedoresUnicos,
    (SELECT COUNT(DISTINCT profissao) FROM dbo.f_financeiro) AS ProfissoesUnicas;

-- Visualização dos primeiros 1000 registros
SELECT TOP 1000 * FROM dbo.f_financeiro;
SELECT TOP 1000 * FROM dbo.f_vendas;

-- Última data de venda registrada
SELECT MAX(DataVenda) AS UltimaVenda FROM dbo.f_vendas;

-- =============================================
-- AGREGAÇÕES POR LOJA E VENDEDOR
-- =============================================

-- Vendas e descontos por loja
SELECT 
    NomeLoja,
    SUM(ValorTotal) AS TotalVendas,
    SUM(Desconto) AS TotalDescontos
FROM dbo.f_vendas
GROUP BY NomeLoja;

-- Vendas e descontos por vendedor
SELECT 
    NomeVendedor,
    SUM(ValorTotal) AS TotalVendas,
    SUM(Desconto) AS TotalDescontos
FROM dbo.f_vendas
GROUP BY NomeVendedor;

-- Total geral de vendas
SELECT SUM(ValorTotal) AS TotalGeralVendas FROM dbo.f_vendas;

-- Total financeiro
SELECT SUM(Valor) AS TotalFinanceiro FROM dbo.f_Financeiro_VIEW;

-- =============================================
-- CRIAÇÃO DA TABELA CALENDÁRIO
-- =============================================

DROP TABLE IF EXISTS dbo.d_Calendario;

CREATE TABLE dbo.d_Calendario (
    Data DATE PRIMARY KEY,
    DiaSemana VARCHAR(13),
    DiaMes INT,
    Mes INT,
    Ano INT
);

-- Inserção de datas usando CTE
WITH Datas AS (
    SELECT CAST('2020-01-01' AS DATE) AS Data
    UNION ALL
    SELECT DATEADD(DAY, 1, Data) FROM Datas
    WHERE Data < '2023-12-31'
)
INSERT INTO dbo.d_Calendario (Data, DiaSemana, DiaMes, Mes, Ano)
SELECT 
    Data,
    DATENAME(WEEKDAY, Data),
    DAY(Data),
    MONTH(Data),
    YEAR(Data)
FROM Datas
OPTION (MAXRECURSION 0);

-- =============================================
-- CRIAÇÃO DE VIEWS
-- =============================================

-- View de vendas
CREATE OR ALTER VIEW dbo.f_Vendas_VIEW AS
SELECT 
    ID,
    DataVenda,
    Produto,
    Quantidade,
    PrecoUnitario,
    Desconto,
    Frete,
    ID_Cliente
FROM dbo.f_vendas;

-- View de clientes em vendas
CREATE OR ALTER VIEW dbo.d_Clientes_Vendas AS
SELECT DISTINCT
    ID_Cliente,
    NomeVendedor,
    NomeLoja,
    StatusCliente
FROM dbo.f_vendas;

-- View de financeiro
CREATE OR ALTER VIEW dbo.f_Financeiro_VIEW AS
SELECT 
    id,
    data,
    tipo,
    valor,
    grupo,
    subgrupo,
    id_cliente
FROM dbo.f_financeiro;

-- View de clientes em financeiro
CREATE OR ALTER VIEW dbo.d_Clientes_Financeiro AS
SELECT DISTINCT
    id_cliente,
    loja,
    estado_civil,
    tipo_renda,
    cidade
FROM dbo.f_financeiro;
