CREATE TABLE [ERP].[MovimientoRendirCuentaDetalle] (
    [ID]                       BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdMovimientoRendirCuenta] INT             NULL,
    [Orden]                    INT             NULL,
    [IdPlanCuenta]             INT             NULL,
    [IdProyecto]               INT             NULL,
    [IdEntidad]                INT             NULL,
    [Nombre]                   VARCHAR (250)   NULL,
    [IdTipoComprobante]        INT             NULL,
    [Serie]                    VARCHAR (4)     NULL,
    [Documento]                VARCHAR (20)    NULL,
    [Total]                    DECIMAL (14, 5) NULL,
    [IdDebeHaber]              INT             NULL,
    [CodigoAuxiliar]           VARCHAR (50)    NULL,
    [FlagTransferencia]        BIT             NULL,
    [IdCuentaPagar]            INT             NULL,
    [IdCuenta]                 INT             NULL,
    [IdMovimientoTesoreria]    INT             NULL,
    [Operacion]                CHAR (1)        NULL,
    CONSTRAINT [PK_MovimientoRendirCuentaDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_RendirCuentaDetalle_PlanCuenta] FOREIGN KEY ([IdPlanCuenta]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK_RendirCuentaDetalle_RendirCuenta] FOREIGN KEY ([IdMovimientoRendirCuenta]) REFERENCES [ERP].[MovimientoRendirCuenta] ([ID])
);

