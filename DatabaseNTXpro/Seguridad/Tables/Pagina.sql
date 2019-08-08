CREATE TABLE [Seguridad].[Pagina] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdModulo]        INT           NULL,
    [Nombre]          VARCHAR (100) NULL,
    [Url]             VARCHAR (100) NULL,
    [Icono]           VARCHAR (100) NULL,
    [Orden]           INT           NULL,
    [IdTamanioPagina] INT           NULL,
    [IdPaginaPadre]   INT           NULL,
    CONSTRAINT [PK_Pagina] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Pagina__IdModulo__2F10007B] FOREIGN KEY ([IdModulo]) REFERENCES [Seguridad].[Modulo] ([ID]),
    CONSTRAINT [FK__Pagina__IdTamani__300424B4] FOREIGN KEY ([IdTamanioPagina]) REFERENCES [Seguridad].[TamanioPagina] ([ID])
);

