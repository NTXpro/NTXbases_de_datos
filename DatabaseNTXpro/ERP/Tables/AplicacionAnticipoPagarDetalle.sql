CREATE TABLE [ERP].[AplicacionAnticipoPagarDetalle] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [IdAplicacionAnticipo] INT             NULL,
    [IdCuentaPagar]        INT             NULL,
    [IdTipoComprobante]    INT             NULL,
    [IdMoneda]             INT             NULL,
    [Documento]            VARCHAR (20)    NULL,
    [Serie]                VARCHAR (4)     NULL,
    [Fecha]                DATETIME        NULL,
    [Total]                DECIMAL (14, 6) NULL,
    [TotalAplicado]        DECIMAL (14, 6) NULL,
    [IdDebeHaber]          INT             NULL,
    CONSTRAINT [PK__Aplicaci__3214EC27DD358923] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Aplicacio__IdApl__7914ADD4] FOREIGN KEY ([IdAplicacionAnticipo]) REFERENCES [ERP].[AplicacionAnticipoPagar] ([ID]),
    CONSTRAINT [FK__Aplicacio__IdCue__7A08D20D] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID]),
    CONSTRAINT [FK__Aplicacio__IdMon__7BF11A7F] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__Aplicacio__IdTip__7AFCF646] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

