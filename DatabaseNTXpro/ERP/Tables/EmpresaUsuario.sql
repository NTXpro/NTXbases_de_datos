CREATE TABLE [ERP].[EmpresaUsuario] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]       INT           NULL,
    [IdUsuario]       INT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_EmpresaUsuario] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_EmpresaUsuario_Empresa] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK_EmpresaUsuario_Usuario] FOREIGN KEY ([IdUsuario]) REFERENCES [Seguridad].[Usuario] ([ID])
);

