CREATE TABLE [ERP].[ConceptoAFPMes] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [IdConceptoAFP] INT NULL,
    [IdMes]         INT NULL,
    CONSTRAINT [PK_ConceptoAFPMes] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConceptoAFP]) REFERENCES [ERP].[ConceptoAFP] ([ID]),
    FOREIGN KEY ([IdMes]) REFERENCES [Maestro].[Mes] ([ID])
);

