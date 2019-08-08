CREATE TABLE [ERP].[FormaPago] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [Dias]            INT           NULL,
    [IdTipoPago]      INT           NULL,
    [IdSistema]       INT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [IdEmpresa]       INT           NULL,
    CONSTRAINT [PK_FormaPago] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_FormaPago_Sistema] FOREIGN KEY ([IdSistema]) REFERENCES [Seguridad].[Sistema] ([ID]),
    CONSTRAINT [FK_FormaPago_TipoPago] FOREIGN KEY ([IdTipoPago]) REFERENCES [ERP].[TipoPago] ([ID])
);

