CREATE TABLE [ERP].[ComprobanteCuentaCobrar] (
    [ID]             INT IDENTITY (1, 1) NOT NULL,
    [IdComprobante]  INT NULL,
    [IdCuentaCobrar] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdComprobante]) REFERENCES [ERP].[Comprobante] ([ID]),
    FOREIGN KEY ([IdCuentaCobrar]) REFERENCES [ERP].[CuentaCobrar] ([ID])
);

