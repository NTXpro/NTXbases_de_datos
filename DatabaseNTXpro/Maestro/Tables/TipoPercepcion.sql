CREATE TABLE [Maestro].[TipoPercepcion] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (50) NULL,
    CONSTRAINT [PK_TipoPercepcion] PRIMARY KEY CLUSTERED ([ID] ASC)
);

