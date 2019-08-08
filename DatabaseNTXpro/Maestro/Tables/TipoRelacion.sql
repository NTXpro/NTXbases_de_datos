CREATE TABLE [Maestro].[TipoRelacion] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (50) NULL,
    [Orden]  INT          NULL,
    CONSTRAINT [PK_TipoRelacion] PRIMARY KEY CLUSTERED ([ID] ASC)
);

