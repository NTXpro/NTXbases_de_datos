CREATE TABLE [ERP].[Parametro] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (50)  NULL,
    [IdPeriodo]       INT           NULL,
    [Abreviatura]     VARCHAR (10)  NULL,
    [Valor]           VARCHAR (MAX) NULL,
    [IdTipoParametro] INT           NULL,
    [FechaRegistro]   DATETIME      NULL,
    [Flag]            BIT           NULL,
    [IdEmpresa]       INT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_Parametro] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Parametro_TipoParametro] FOREIGN KEY ([IdTipoParametro]) REFERENCES [Maestro].[TipoParametro] ([ID])
);

