CREATE TABLE [Seguridad].[Usuario] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [IdEntidad]         INT           NULL,
    [Correo]            VARCHAR (100) NULL,
    [Clave]             VARCHAR (20)  NULL,
    [IdVersion]         INT           NULL,
    [FechaRegistro]     DATETIME      NULL,
    [FechaEliminado]    DATETIME      NULL,
    [FlagAdministrador] BIT           NULL,
    [FlagBorrador]      BIT           NULL,
    [Flag]              BIT           NULL,
    [FechaModificado]   DATETIME      NULL,
    [UsuarioRegistro]   VARCHAR (250) NULL,
    [UsuarioModifico]   VARCHAR (250) NULL,
    [UsuarioElimino]    VARCHAR (250) NULL,
    [UsuarioActivo]     VARCHAR (250) NULL,
    [FechaActivacion]   DATETIME      NULL,
    [IdProyecto]        INT           NULL,
    CONSTRAINT [PK__Usuario__5B65BF978DB3F5FC] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Usuario_Entidad] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK_Usuario_Version] FOREIGN KEY ([IdVersion]) REFERENCES [ERP].[Version] ([ID])
);

