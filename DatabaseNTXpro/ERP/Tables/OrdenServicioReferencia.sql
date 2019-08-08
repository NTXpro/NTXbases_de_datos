CREATE TABLE [ERP].[OrdenServicioReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdOrdenServicio]    INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (20) NULL,
    [FlagInterno]        BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__OrdenServ__IdOrd__3104CC93] FOREIGN KEY ([IdOrdenServicio]) REFERENCES [ERP].[OrdenServicio] ([ID])
);

