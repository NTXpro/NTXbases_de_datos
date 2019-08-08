CREATE TABLE [ERP].[Ubicacion] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Codigo]          VARCHAR (20)  NULL,
    [Nombre]          VARCHAR (100) NULL,
    [IdAlmacen]       INT           NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    CONSTRAINT [PK_Ubicacion] PRIMARY KEY CLUSTERED ([ID] ASC)
);

