CREATE TABLE [Maestro].[Clase] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (50) NULL,
    [Codigo] VARCHAR (10) NULL,
    [Orden]  INT          NULL,
    CONSTRAINT [PK_ConceptoClase] PRIMARY KEY CLUSTERED ([ID] ASC)
);

