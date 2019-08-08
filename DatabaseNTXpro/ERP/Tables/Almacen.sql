CREATE TABLE [ERP].[Almacen] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]         INT           NULL,
    [Nombre]            VARCHAR (50)  NULL,
    [IdEstablecimiento] INT           NULL,
    [FechaRegistro]     DATETIME      NULL,
    [FechaEliminado]    DATETIME      NULL,
    [FlagBorrador]      BIT           NULL,
    [Flag]              BIT           NULL,
    [FlagPrincipal]     BIT           NULL,
    [FechaModificado]   DATETIME      NULL,
    [UsuarioRegistro]   VARCHAR (250) NULL,
    [UsuarioModifico]   VARCHAR (250) NULL,
    [UsuarioElimino]    VARCHAR (250) NULL,
    [UsuarioActivo]     VARCHAR (250) NULL,
    [FechaActivacion]   DATETIME      NULL,
    CONSTRAINT [PK_Almacen] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Almacen_Empresa] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK_Almacen_Establecimiento] FOREIGN KEY ([IdEstablecimiento]) REFERENCES [ERP].[Establecimiento] ([ID])
);

