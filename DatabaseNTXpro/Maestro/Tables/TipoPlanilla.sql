CREATE TABLE [Maestro].[TipoPlanilla] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (50) NULL,
    [Codigo] VARCHAR (50) NULL,
    CONSTRAINT [PK_TipoPlanilla] PRIMARY KEY CLUSTERED ([ID] ASC)
);

