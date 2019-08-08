CREATE TABLE [ERP].[RequerimientoReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdRequerimiento]    INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (20) NULL,
    [FlagInterno]        BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdRequerimiento]) REFERENCES [ERP].[Requerimiento] ([ID])
);

