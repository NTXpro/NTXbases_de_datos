CREATE TABLE [ERP].[Proveedor] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEntidad]       INT           NOT NULL,
    [IdEmpresa]       INT           NOT NULL,
    [idTipoRelacion]  INT           NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            NCHAR (10)    NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [DiasVencimiento] INT           NULL,
    [Correo]          VARCHAR (250) NULL,
    CONSTRAINT [PK__Proveedo__3214EC27BA22C2D2] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Proveedor__IdEmp__0E8E2250] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Proveedor__IdEnt__0D99FE17] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK_Proveedor_TipoRelacion] FOREIGN KEY ([idTipoRelacion]) REFERENCES [Maestro].[TipoRelacion] ([ID])
);

