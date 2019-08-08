CREATE TABLE [Maestro].[Grado] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]    VARCHAR (50) NULL,
    [Longitud]  INT          NULL,
    [IdEmpresa] INT          NULL,
    [IdAnio]    INT          NULL,
    CONSTRAINT [PK_Grado] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID])
);

