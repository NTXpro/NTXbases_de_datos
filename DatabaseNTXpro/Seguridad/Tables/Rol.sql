CREATE TABLE [Seguridad].[Rol] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]                VARCHAR (50)  NULL,
    [FechaRegistro]         DATETIME      NULL,
    [FechaEliminado]        DATETIME      NULL,
    [FlagBorrador]          BIT           NULL,
    [Flag]                  BIT           NULL,
    [FechaModificado]       DATETIME      NULL,
    [UsuarioModifico]       VARCHAR (250) NULL,
    [UsuarioElimino]        VARCHAR (250) NULL,
    [UsuarioRegistro]       VARCHAR (250) NULL,
    [UsuarioActivo]         VARCHAR (250) NULL,
    [FechaActivado]         DATETIME      NULL,
    [FechaModificadoPerfil] DATETIME      NULL,
    [UsuarioModificoPerfil] VARCHAR (250) NULL,
    CONSTRAINT [PK__Rol__3214EC27859DA72A] PRIMARY KEY CLUSTERED ([ID] ASC)
);

