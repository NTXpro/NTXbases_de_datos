CREATE TABLE [Maestro].[TipoConcepto] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (250) NULL,
    [Codigo] VARCHAR (10)  NULL,
    CONSTRAINT [PK_TipoConcepto] PRIMARY KEY CLUSTERED ([ID] ASC)
);

