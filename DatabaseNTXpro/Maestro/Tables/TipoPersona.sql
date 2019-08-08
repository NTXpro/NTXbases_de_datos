CREATE TABLE [Maestro].[TipoPersona] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (20) NULL,
    [Abreviatura] CHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

