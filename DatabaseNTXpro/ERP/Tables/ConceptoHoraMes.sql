CREATE TABLE [ERP].[ConceptoHoraMes] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [IdConceptoHora] INT             NULL,
    [IdMes]          INT             NULL,
    [Factor]         DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_ConceptoHoraMes] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConceptoHora]) REFERENCES [ERP].[ConceptoHora] ([ID]),
    FOREIGN KEY ([IdMes]) REFERENCES [Maestro].[Mes] ([ID])
);

