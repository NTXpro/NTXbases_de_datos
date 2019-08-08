CREATE TABLE [ERP].[Version] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (20)  NULL,
    [Abreviatura]     CHAR (1)      NULL,
    [Indicador]       INT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK__Version__3214EC27B07F7342] PRIMARY KEY CLUSTERED ([ID] ASC)
);

