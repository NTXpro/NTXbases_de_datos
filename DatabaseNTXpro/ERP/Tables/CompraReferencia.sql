﻿CREATE TABLE [ERP].[CompraReferencia] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [IdCompra]           INT          NULL,
    [IdReferenciaOrigen] INT          NULL,
    [IdReferencia]       INT          NULL,
    [IdTipoComprobante]  INT          NULL,
    [Serie]              VARCHAR (20) NULL,
    [Documento]          VARCHAR (20) NULL,
    [FlagInterno]        BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID]),
    FOREIGN KEY ([IdReferenciaOrigen]) REFERENCES [Maestro].[ReferenciaOrigen] ([ID]),
    FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);
