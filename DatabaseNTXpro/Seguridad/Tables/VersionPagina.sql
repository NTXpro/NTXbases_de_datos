CREATE TABLE [Seguridad].[VersionPagina] (
    [ID]        INT IDENTITY (1, 1) NOT NULL,
    [IdVersion] INT NOT NULL,
    [IdPagina]  INT NOT NULL,
    [Flag]      BIT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__VersionPa__IdPag__5A4F643B] FOREIGN KEY ([IdPagina]) REFERENCES [Seguridad].[Pagina] ([ID]),
    CONSTRAINT [FK__VersionPa__IdVer__5B438874] FOREIGN KEY ([IdVersion]) REFERENCES [ERP].[Version] ([ID])
);

