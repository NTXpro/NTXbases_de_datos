CREATE TABLE [Maestro].[Propiedad] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [IdUnidadMedida]  INT           NULL,
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
    CONSTRAINT [PK_Propiedad] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__PROPIEDAD__IdUni__43C1049E] FOREIGN KEY ([IdUnidadMedida]) REFERENCES [PLE].[T6UnidadMedida] ([ID])
);

