CREATE TABLE [ERP].[ValeTransferenciaReferencia] (
    [ID]                  INT          IDENTITY (1, 1) NOT NULL,
    [IdValeTransferencia] INT          NULL,
    [IdReferenciaOrigen]  INT          NULL,
    [IdReferencia]        INT          NULL,
    [IdTipoComprobante]   INT          NULL,
    [Serie]               VARCHAR (20) NULL,
    [Documento]           VARCHAR (20) NULL,
    [FlagInterno]         BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdValeTransferencia]) REFERENCES [ERP].[ValeTransferencia] ([ID])
);

