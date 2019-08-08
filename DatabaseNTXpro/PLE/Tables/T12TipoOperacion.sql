CREATE TABLE [PLE].[T12TipoOperacion] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]           VARCHAR (250) NULL,
    [CodigoSunat]      VARCHAR (10)  NULL,
    [UsuarioRegistro]  VARCHAR (250) NULL,
    [FechaRegistro]    DATETIME      NULL,
    [UsuarioModifico]  VARCHAR (250) NULL,
    [FechaModificado]  DATETIME      NULL,
    [UsuarioElimino]   VARCHAR (250) NULL,
    [FechaEliminado]   DATETIME      NULL,
    [UsuarioActivo]    VARCHAR (250) NULL,
    [FechaActivacion]  DATETIME      NULL,
    [FlagSunat]        BIT           NULL,
    [FlagBorrador]     BIT           NULL,
    [Flag]             BIT           NULL,
    [FlagCostear]      BIT           NULL,
    [IdTipoMovimiento] INT           NULL,
    CONSTRAINT [PK_T12Operacion] PRIMARY KEY CLUSTERED ([ID] ASC)
);

