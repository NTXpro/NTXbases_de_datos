CREATE TABLE [ERP].[PedidoReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdPedido]           INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (30) NULL,
    [FlagInterno]        BIT          NULL,
    CONSTRAINT [FK__PedidoRef__IdPed__79C9A642] FOREIGN KEY ([IdPedido]) REFERENCES [ERP].[Pedido] ([ID])
);

