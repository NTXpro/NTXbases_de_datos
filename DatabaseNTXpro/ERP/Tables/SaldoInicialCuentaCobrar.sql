CREATE TABLE [ERP].[SaldoInicialCuentaCobrar] (
    [ID]                   INT IDENTITY (1, 1) NOT NULL,
    [IdSaldoInicialCobrar] INT NULL,
    [IdCuentaCobrar]       INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCuentaCobrar]) REFERENCES [ERP].[CuentaCobrar] ([ID]),
    FOREIGN KEY ([IdSaldoInicialCobrar]) REFERENCES [ERP].[SaldoInicialCobrar] ([ID])
);

