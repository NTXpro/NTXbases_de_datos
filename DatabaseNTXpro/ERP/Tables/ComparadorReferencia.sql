CREATE TABLE [ERP].[ComparadorReferencia] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IdComparador]       INT             NULL,
    [IdReferenciaOrigen] INT             NULL,
    [IdReferencia]       INT             NULL,
    [IdTipoComprobante]  INT             NULL,
    [Serie]              VARCHAR (20)    NULL,
    [Documento]          VARCHAR (20)    NULL,
    [FlagInterno]        BIT             NULL,
    [Total]              DECIMAL (14, 5) NULL,
    FOREIGN KEY ([IdComparador]) REFERENCES [ERP].[Comparador] ([ID]),
    FOREIGN KEY ([IdReferenciaOrigen]) REFERENCES [Maestro].[ReferenciaOrigen] ([ID]),
    FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

