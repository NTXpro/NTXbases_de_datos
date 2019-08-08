CREATE TABLE [PLE].[T5Existencia] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [CodigoSunat]     CHAR (2)      NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagSunat]       BIT           NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK__T5Existe__3214EC272A469F94] PRIMARY KEY CLUSTERED ([ID] ASC)
);

