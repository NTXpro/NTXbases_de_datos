CREATE TABLE [ERP].[ImportacionReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdImportacion]      INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (20) NULL,
    [FlagInterno]        INT          NULL,
    CONSTRAINT [PK_ImportacionReferencia] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdReferenciaOrigen]) REFERENCES [Maestro].[ReferenciaOrigen] ([ID]),
    FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID]),
    CONSTRAINT [FK__Importaci__IdImp__4560CAFB] FOREIGN KEY ([IdImportacion]) REFERENCES [ERP].[Importacion] ([ID])
);

