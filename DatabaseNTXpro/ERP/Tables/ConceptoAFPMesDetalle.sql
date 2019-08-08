CREATE TABLE [ERP].[ConceptoAFPMesDetalle] (
    [ID]               INT IDENTITY (1, 1) NOT NULL,
    [IdConceptoAFPMes] INT NULL,
    [IdConcepto]       INT NULL,
    CONSTRAINT [PK_ConceptoAFPMesDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    FOREIGN KEY ([IdConceptoAFPMes]) REFERENCES [ERP].[ConceptoAFPMes] ([ID])
);

