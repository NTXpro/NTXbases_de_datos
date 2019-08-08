CREATE TABLE [ERP].[ConceptoHora] (
    [ID]         INT IDENTITY (1, 1) NOT NULL,
    [IdConcepto] INT NULL,
    [IdAnio]     INT NULL,
    CONSTRAINT [PK_ConceptoHora] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID]),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID])
);

