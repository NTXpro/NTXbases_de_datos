CREATE TABLE [ERP].[CuentaPagarMovimiento] (
    [ID]                INT IDENTITY (1, 1) NOT NULL,
    [IdCuentaPagar]     INT NOT NULL,
    [IdCuentaPagarHijo] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__CuentaPag__IdCue__10E14A6D] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID]),
    CONSTRAINT [FK__CuentaPag__IdCue__11D56EA6] FOREIGN KEY ([IdCuentaPagarHijo]) REFERENCES [ERP].[CuentaPagar] ([ID])
);

