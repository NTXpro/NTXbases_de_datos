CREATE TABLE [ERP].[LetraCobrarCuentaCobrar] (
    [ID]             INT IDENTITY (1, 1) NOT NULL,
    [IdLetraCobrar]  INT NULL,
    [IdCuentaCobrar] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCuentaCobrar]) REFERENCES [ERP].[CuentaCobrar] ([ID]),
    FOREIGN KEY ([IdLetraCobrar]) REFERENCES [ERP].[LetraCobrar] ([ID])
);

