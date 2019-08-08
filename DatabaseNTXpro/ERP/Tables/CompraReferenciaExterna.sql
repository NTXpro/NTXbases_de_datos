CREATE TABLE [ERP].[CompraReferenciaExterna] (
    [ID]                  INT          IDENTITY (1, 1) NOT NULL,
    [IdCompra]            INT          NULL,
    [IdTipoComprobante]   INT          NULL,
    [SerieReferencia]     VARCHAR (20) NULL,
    [DocumentoReferencia] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID]),
    FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

