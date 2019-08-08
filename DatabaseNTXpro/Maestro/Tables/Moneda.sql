CREATE TABLE [Maestro].[Moneda] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [CodigoSunat] CHAR (3)     NULL,
    [Simbolo]     CHAR (4)     NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

