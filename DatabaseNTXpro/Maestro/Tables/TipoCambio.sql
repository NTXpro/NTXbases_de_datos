CREATE TABLE [Maestro].[TipoCambio] (
    [ID]          INT          NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] CHAR (1)     NULL,
    CONSTRAINT [PK_TipoCambio] PRIMARY KEY CLUSTERED ([ID] ASC)
);

