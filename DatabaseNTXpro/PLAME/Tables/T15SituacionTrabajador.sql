CREATE TABLE [PLAME].[T15SituacionTrabajador] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (250) NULL,
    [Descripcion] VARCHAR (250) NULL,
    [CodigoSunat] VARCHAR (2)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

