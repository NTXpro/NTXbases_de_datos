CREATE TABLE [ERP].[ComprobanteReferenciaInterno] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [IdComprobante]           INT           NULL,
    [IdComprobanteReferencia] INT           NULL,
    [FechaModificado]         DATETIME      NULL,
    [UsuarioRegistro]         VARCHAR (250) NULL,
    [UsuarioModifico]         VARCHAR (250) NULL,
    [UsuarioElimino]          VARCHAR (250) NULL,
    [UsuarioActivo]           VARCHAR (250) NULL,
    [FechaActivacion]         DATETIME      NULL,
    CONSTRAINT [PK_Referencia] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Referencia_Comprobante] FOREIGN KEY ([IdComprobante]) REFERENCES [ERP].[Comprobante] ([ID]),
    CONSTRAINT [FK_Referencia_Comprobante1] FOREIGN KEY ([IdComprobanteReferencia]) REFERENCES [ERP].[Comprobante] ([ID])
);

