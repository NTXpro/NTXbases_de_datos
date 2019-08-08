CREATE TABLE [Seguridad].[Sistema] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [IdAplicacion] INT           NOT NULL,
    [Nombre]       VARCHAR (250) NULL,
    [Orden]        INT           NULL,
    CONSTRAINT [PK__Sistema__3214EC274EED782D] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Modulo__IdAplica__145C0A3F] FOREIGN KEY ([IdAplicacion]) REFERENCES [Seguridad].[Aplicacion] ([ID])
);

