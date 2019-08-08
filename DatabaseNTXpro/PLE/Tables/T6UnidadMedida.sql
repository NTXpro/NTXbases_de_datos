CREATE TABLE [PLE].[T6UnidadMedida] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [CodigoSunat]     CHAR (3)      NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagSunat]       BIT           NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [FechaModificado] DATETIME      NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    CONSTRAINT [PK__UnidadMe__3214EC270690875C] PRIMARY KEY CLUSTERED ([ID] ASC)
);

