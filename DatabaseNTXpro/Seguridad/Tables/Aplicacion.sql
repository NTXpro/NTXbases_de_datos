CREATE TABLE [Seguridad].[Aplicacion] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (200) NULL,
    [Orden]       INT           NULL,
    [Url]         VARCHAR (200) NULL,
    [Abreviatura] VARCHAR (4)   NULL,
    CONSTRAINT [PK__Aplicaci__18C0D2DE9AB96A28] PRIMARY KEY CLUSTERED ([ID] ASC)
);

