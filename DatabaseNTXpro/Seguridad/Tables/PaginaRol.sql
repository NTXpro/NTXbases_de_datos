CREATE TABLE [Seguridad].[PaginaRol] (
    [ID]        INT IDENTITY (1, 1) NOT NULL,
    [IdRol]     INT NOT NULL,
    [IdPagina]  INT NOT NULL,
    [Ver]       BIT NULL,
    [Nuevo]     BIT NULL,
    [Editar]    BIT NULL,
    [Eliminar]  BIT NULL,
    [Restaurar] BIT NULL,
    CONSTRAINT [PK__PaginaRo__3214EC272D336B91] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__PaginaRol__IdPag__147C05D0] FOREIGN KEY ([IdPagina]) REFERENCES [Seguridad].[Pagina] ([ID]),
    CONSTRAINT [FK__PaginaRol__IdRol__1387E197] FOREIGN KEY ([IdRol]) REFERENCES [Seguridad].[Rol] ([ID])
);

