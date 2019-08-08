CREATE TABLE [ERP].[ConceptoAFP] (
    [ID]               INT IDENTITY (1, 1) NOT NULL,
    [IdConcepto]       INT NULL,
    [IdAnio]           INT NULL,
    [IdRegimenLaboral] INT NULL,
    CONSTRAINT [PK_ConceptoAFP] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID]),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    FOREIGN KEY ([IdRegimenLaboral]) REFERENCES [PLAME].[T33RegimenLaboral] ([ID])
);

