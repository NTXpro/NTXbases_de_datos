CREATE TABLE [Maestro].[TransformacionServicio] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (250) NULL,
    [Descripcion]     VARCHAR (250) NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

