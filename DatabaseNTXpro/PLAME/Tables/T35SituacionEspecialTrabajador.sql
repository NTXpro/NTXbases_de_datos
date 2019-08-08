CREATE TABLE [PLAME].[T35SituacionEspecialTrabajador] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (150) NULL,
    [Descripcion] VARCHAR (150) NULL,
    [CodigoSunat] VARCHAR (2)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

