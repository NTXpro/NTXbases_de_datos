CREATE TABLE [ERP].[MovimientoTransferenciaMasivaCuentaDetalle] (
    [ID]                                    INT             IDENTITY (1, 1) NOT NULL,
    [IdCuentaReceptor]                      INT             NOT NULL,
    [IdCategoriaTipoMovimientoReceptor]     INT             NOT NULL,
    [IdProyecto]                            INT             NULL,
    [IdDebeHaber]                           INT             NULL,
    [IdMovimientoTesoreriaReceptor]         INT             NULL,
    [MontoReceptor]                         DECIMAL (14, 5) NULL,
    [IdMovimientoTransferenciaMasivaCuenta] INT             NULL,
    [Orden]                                 INT             NULL,
    CONSTRAINT [PK__Movimien__3214EC275EFE9A36] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdMovimientoTransferenciaMasivaCuenta]) REFERENCES [ERP].[MovimientoTransferenciaMasivaCuenta] ([ID]),
    CONSTRAINT [FK__Movimient__IdCat__167BBEE0] FOREIGN KEY ([IdCategoriaTipoMovimientoReceptor]) REFERENCES [Maestro].[CategoriaTipoMovimiento] ([ID]),
    CONSTRAINT [FK__Movimient__IdCue__15879AA7] FOREIGN KEY ([IdCuentaReceptor]) REFERENCES [ERP].[Cuenta] ([ID]),
    CONSTRAINT [FK__Movimient__IdMov__176FE319] FOREIGN KEY ([IdMovimientoTesoreriaReceptor]) REFERENCES [ERP].[MovimientoTesoreria] ([ID])
);

