CREATE TABLE [ERP].[CompraCuentaPagar] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [IdCompra]      INT NULL,
    [IdCuentaPagar] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID]),
    CONSTRAINT [FK__CompraCue__IdCue__0742D19A] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID])
);

