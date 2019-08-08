CREATE TABLE [PLE].[T3Banco] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEntidad]       INT           NULL,
    [CodigoSunat]     CHAR (2)      NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagSunat]       BIT           NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [FechaModificado] DATETIME      NULL,
    CONSTRAINT [PK_PLE.T3Banco] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PLE.T3Banco_Entidad] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID])
);

