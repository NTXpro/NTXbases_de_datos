CREATE TABLE [Maestro].[TransformacionEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] VARCHAR (10) NULL,
    CONSTRAINT [PK_TransformacionEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

