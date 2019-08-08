CREATE TABLE [Maestro].[TipoMovimiento] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] CHAR (1)     NULL,
    CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED ([ID] ASC)
);

