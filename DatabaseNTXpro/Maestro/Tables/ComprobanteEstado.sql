CREATE TABLE [Maestro].[ComprobanteEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] VARCHAR (2)  NULL,
    CONSTRAINT [PK_ComprobanteEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

