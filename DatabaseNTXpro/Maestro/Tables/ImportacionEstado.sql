CREATE TABLE [Maestro].[ImportacionEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] VARCHAR (10) NULL,
    CONSTRAINT [PK_ImportacionEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

