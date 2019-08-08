CREATE TABLE [ERP].[AplicacionAnticipoCobrarDetalle] (
    [ID]                         INT             IDENTITY (1, 1) NOT NULL,
    [IdAplicacionAnticipoCobrar] INT             NULL,
    [IdCuentaCobrar]             INT             NULL,
    [IdTipoComprobante]          INT             NULL,
    [IdMoneda]                   INT             NULL,
    [Documento]                  VARCHAR (20)    NULL,
    [Serie]                      VARCHAR (4)     NULL,
    [Total]                      DECIMAL (14, 5) NULL,
    [TotalAplicado]              DECIMAL (14, 5) NULL,
    [Fecha]                      DATETIME        NULL,
    [IdDebeHaber]                INT             NULL,
    CONSTRAINT [PK__Aplicaci__3214EC27E569A864] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Aplicacio__IdApl__71C891C7] FOREIGN KEY ([IdAplicacionAnticipoCobrar]) REFERENCES [ERP].[AplicacionAnticipoCobrar] ([ID]),
    CONSTRAINT [FK__Aplicacio__IdCue__72BCB600] FOREIGN KEY ([IdCuentaCobrar]) REFERENCES [ERP].[CuentaCobrar] ([ID]),
    CONSTRAINT [FK__Aplicacio__IdMon__74A4FE72] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__Aplicacio__IdTip__73B0DA39] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

