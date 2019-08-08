CREATE TABLE [ERP].[LetraPagarCuentaPagar] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [IdLetraPagar]  INT NULL,
    [IdCuentaPagar] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID]),
    FOREIGN KEY ([IdLetraPagar]) REFERENCES [ERP].[LetraPagar] ([ID])
);

