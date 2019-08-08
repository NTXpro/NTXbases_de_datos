CREATE TABLE [ERP].[CompraReferenciaInterna] (
    [ID]                 INT IDENTITY (1, 1) NOT NULL,
    [IdCompra]           INT NULL,
    [IdCompraReferencia] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID])
);

