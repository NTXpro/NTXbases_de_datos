CREATE TABLE [XML].[T10MotivoNotaDebito] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (250) NULL,
    [CodigoSunat] CHAR (2)      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

