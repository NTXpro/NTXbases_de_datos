CREATE TABLE [ERP].[ConceptoPorcentajeMesDetalle] (
    [ID]                      INT IDENTITY (1, 1) NOT NULL,
    [IdConceptoPorcentajeMes] INT NULL,
    [IdConcepto]              INT NULL,
    CONSTRAINT [PK_ConceptoPorcentajeDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    FOREIGN KEY ([IdConceptoPorcentajeMes]) REFERENCES [ERP].[ConceptoPorcentajeMes] ([ID])
);

