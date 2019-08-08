CREATE TABLE [ERP].[Transporte] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEntidad]       INT           NULL,
    [IdEmpresa]       INT           NULL,
    [Flag]            BIT           NULL,
    [FlagBorrador]    BIT           NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaModificado] DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FechaActivacion] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Transport__IdEnt__4E952F7A] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID])
);

