CREATE TABLE [ERP].[MovimientoConciliacionPendiente] (
    [ID]                       INT IDENTITY (1, 1) NOT NULL,
    [IdMovimientoConciliacion] INT NULL,
    [IdMovimientoTesoreria]    INT NULL,
    [FlagPendiente]            BIT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdMovimientoConciliacion]) REFERENCES [ERP].[MovimientoConciliacion] ([ID]),
    FOREIGN KEY ([IdMovimientoTesoreria]) REFERENCES [ERP].[MovimientoTesoreria] ([ID])
);

