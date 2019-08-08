CREATE TABLE [ERP].[ComprobanteReferenciaExterno] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IdComprobante]       INT           NULL,
    [IdTipoComprobante]   INT           NULL,
    [SerieReferencia]     VARCHAR (4)   NULL,
    [DocumentoReferencia] VARCHAR (20)  NULL,
    [FechaModificado]     DATETIME      NULL,
    [UsuarioRegistro]     VARCHAR (250) NULL,
    [UsuarioModifico]     VARCHAR (250) NULL,
    [UsuarioElimino]      VARCHAR (250) NULL,
    [UsuarioActivo]       VARCHAR (250) NULL,
    [FechaActivacion]     DATETIME      NULL,
    CONSTRAINT [PK__Comproba__3214EC2775B4AF73] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Comproban__IdCom__16F94B1F] FOREIGN KEY ([IdComprobante]) REFERENCES [ERP].[Comprobante] ([ID]),
    CONSTRAINT [FK__Comproban__IdTip__17ED6F58] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

