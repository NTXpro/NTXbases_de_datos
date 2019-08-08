CREATE TABLE [Maestro].[Marca] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [FechaModificado] DATETIME      NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    CONSTRAINT [PK__Marca__3214EC2788DBD6B1] PRIMARY KEY CLUSTERED ([ID] ASC)
);

