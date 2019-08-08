CREATE TABLE [ERP].[GuiaRemisionReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdGuiaRemision]     INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (8)  NULL,
    [Documento]          VARCHAR (20) NULL,
    [FlagInterno]        BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdReferenciaOrigen]) REFERENCES [Maestro].[ReferenciaOrigen] ([ID]),
    FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdGui__19183469] FOREIGN KEY ([IdGuiaRemision]) REFERENCES [ERP].[GuiaRemision] ([ID])
);

