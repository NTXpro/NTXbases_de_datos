CREATE TABLE [ERP].[MovimientoTesoreriaDetalleCuentaPagar] (
    [ID]                           BIGINT IDENTITY (1, 1) NOT NULL,
    [IdCuentaPagar]                INT    NULL,
    [IdMovimientoTesoreriaDetalle] BIGINT NULL,
    CONSTRAINT [PK__Movimien__3214EC27AB3D611A] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Movimient__IdCue__181857E1] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID]),
    CONSTRAINT [FK__Movimient__IdMov__190C7C1A] FOREIGN KEY ([IdMovimientoTesoreriaDetalle]) REFERENCES [ERP].[MovimientoTesoreriaDetalle] ([ID])
);

