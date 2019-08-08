CREATE TABLE [ERP].[AnticipoCompraCuentaPagar] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [IdAnticipo]    INT NULL,
    [IdCuentaPagar] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdAnticipo]) REFERENCES [ERP].[AnticipoCompra] ([ID]),
    CONSTRAINT [FK__AnticipoC__IdCue__61130711] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID])
);

