CREATE TABLE [XML].[T20MotivoTraslado] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdTipoOperacion] INT           NULL,
    [Nombre]          VARCHAR (250) NULL,
    [CodigoSunat]     VARCHAR (8)   NULL,
    CONSTRAINT [PK__T20Motiv__3214EC2704C5D417] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdTipoOperacion]) REFERENCES [PLE].[T12TipoOperacion] ([ID])
);

