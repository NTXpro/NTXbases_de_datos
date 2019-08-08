CREATE TABLE [ERP].[AnticipoVentaCuentaCobrar] (
    [ID]             INT IDENTITY (1, 1) NOT NULL,
    [IdAnticipo]     INT NULL,
    [IdCuentaCobrar] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdAnticipo]) REFERENCES [ERP].[AnticipoVenta] ([ID])
);

