CREATE TABLE [ERP].[MovimientoTesoreriaDetalleCuentaCobrar] (
    [ID]                           BIGINT IDENTITY (1, 1) NOT NULL,
    [IdCuentaCobrar]               INT    NOT NULL,
    [IdMovimientoTesoreriaDetalle] BIGINT NOT NULL,
    CONSTRAINT [FK__Movimient__IdCue__34B4968F] FOREIGN KEY ([IdCuentaCobrar]) REFERENCES [ERP].[CuentaCobrar] ([ID]),
    CONSTRAINT [FK__Movimient__IdMov__35A8BAC8] FOREIGN KEY ([IdMovimientoTesoreriaDetalle]) REFERENCES [ERP].[MovimientoTesoreriaDetalle] ([ID])
);

