CREATE TABLE [XML].[T9MotivoNotaCredito] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (250) NULL,
    [CodigoSunat]     CHAR (2)      NULL,
    [IdTipoOperacion] INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

