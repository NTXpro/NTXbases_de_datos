CREATE TABLE [ERP].[CotizacionReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdCotizacion]       INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (30) NULL,
    [FlagInterno]        BIT          NULL,
    CONSTRAINT [FK__Cotizacio__IdCot__4461B9CA] FOREIGN KEY ([IdCotizacion]) REFERENCES [ERP].[Cotizacion] ([ID])
);

