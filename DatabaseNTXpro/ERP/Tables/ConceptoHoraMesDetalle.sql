CREATE TABLE [ERP].[ConceptoHoraMesDetalle] (
    [ID]                INT IDENTITY (1, 1) NOT NULL,
    [IdConceptoHoraMes] INT NULL,
    [IdConcepto]        INT NULL,
    CONSTRAINT [PK_ConceptoHoraMesDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    FOREIGN KEY ([IdConceptoHoraMes]) REFERENCES [ERP].[ConceptoHoraMes] ([ID])
);

