CREATE TABLE [ERP].[ComprobanteObservacion] (
    [ID]              INT           NOT NULL,
    [IdComprobante]   INT           NULL,
    [Observacion]     VARCHAR (255) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_ComprobanteObservacion] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ComprobanteObservacion_Comprobante] FOREIGN KEY ([IdComprobante]) REFERENCES [ERP].[Comprobante] ([ID])
);

