CREATE TABLE [Seguridad].[UsuarioRol] (
    [ID]        INT IDENTITY (1, 1) NOT NULL,
    [IdUsuario] INT NULL,
    [IdRol]     INT NULL,
    CONSTRAINT [PK__UsuarioR__3214EC27C951E96A] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__UsuarioRo__IdRol__0FB750B3] FOREIGN KEY ([IdRol]) REFERENCES [Seguridad].[Rol] ([ID]),
    CONSTRAINT [FK__UsuarioRo__IdUsu__10AB74EC] FOREIGN KEY ([IdUsuario]) REFERENCES [Seguridad].[Usuario] ([ID])
);

