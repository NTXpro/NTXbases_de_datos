CREATE TABLE [Maestro].[TipoProyecto] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (100) NULL,
    CONSTRAINT [PK_TipoProyecto] PRIMARY KEY CLUSTERED ([ID] ASC)
);

