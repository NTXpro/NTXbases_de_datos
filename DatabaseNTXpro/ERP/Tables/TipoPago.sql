CREATE TABLE [ERP].[TipoPago] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_TipoPago] PRIMARY KEY CLUSTERED ([ID] ASC)
);

