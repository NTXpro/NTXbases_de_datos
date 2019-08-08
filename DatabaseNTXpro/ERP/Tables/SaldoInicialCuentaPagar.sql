CREATE TABLE [ERP].[SaldoInicialCuentaPagar] (
    [ID]             INT IDENTITY (1, 1) NOT NULL,
    [IdSaldoInicial] INT NULL,
    [IdCuentaPagar]  INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__SaldoInic__IdCue__3F872ABD] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID]),
    CONSTRAINT [FK__SaldoInic__IdSal__3E930684] FOREIGN KEY ([IdSaldoInicial]) REFERENCES [ERP].[SaldoInicial] ([ID])
);

