CREATE TABLE [ERP].[ConceptoPorcentajeMes] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [IdConceptoPorcentaje] INT             NULL,
    [IdMes]                INT             NULL,
    [Porcentaje]           DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_ConceptoPorcentajeMes] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConceptoPorcentaje]) REFERENCES [ERP].[ConceptoPorcentaje] ([ID]),
    FOREIGN KEY ([IdMes]) REFERENCES [Maestro].[Mes] ([ID])
);

