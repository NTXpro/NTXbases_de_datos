CREATE TABLE [ERP].[GastoCuentaPagar] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [IdGasto]       INT NULL,
    [IdCuentaPagar] INT NULL,
    FOREIGN KEY ([IdGasto]) REFERENCES [ERP].[Gasto] ([ID]),
    CONSTRAINT [FK__GastoCuen__IdCue__2AB6F660] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID])
);

