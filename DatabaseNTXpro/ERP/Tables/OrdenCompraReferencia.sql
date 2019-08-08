CREATE TABLE [ERP].[OrdenCompraReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdOrdenCompra]      INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (20) NULL,
    [FlagInterno]        BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__OrdenComp__IdOrd__3104CC93] FOREIGN KEY ([IdOrdenCompra]) REFERENCES [ERP].[OrdenCompra] ([ID])
);

