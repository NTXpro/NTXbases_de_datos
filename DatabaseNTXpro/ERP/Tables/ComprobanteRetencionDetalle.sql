CREATE TABLE [ERP].[ComprobanteRetencionDetalle] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [IdComprobanteRetencion] INT             NOT NULL,
    [Orden]                  INT             NOT NULL,
    [IdComprobante]          INT             NULL,
    [MontoPagadoSoles]       DECIMAL (14, 5) NULL,
    [MontoPagadoDolares]     DECIMAL (14, 5) NULL,
    [MontoRetenidoSoles]     DECIMAL (14, 5) NULL,
    [MontoRetenidoDolares]   DECIMAL (14, 5) NULL,
    [IdSaldoInicial]         INT             NULL,
    CONSTRAINT [PK_ComprobanteRetencionDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ComprobanteRetencionDetalle_Comprobante] FOREIGN KEY ([IdComprobante]) REFERENCES [ERP].[Comprobante] ([ID]),
    CONSTRAINT [FK_ComprobanteRetencionDetalle_ComprobanteRetencion] FOREIGN KEY ([IdComprobanteRetencion]) REFERENCES [ERP].[ComprobanteRetencion] ([ID])
);

