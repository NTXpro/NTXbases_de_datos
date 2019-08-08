CREATE TABLE [ERP].[ConceptoAFPMesPorcentaje] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [IdConceptoAFPMes] INT             NULL,
    [IdAFP]            INT             NULL,
    [Porcentaje]       DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_ConceptoAFPMesPorcentaje] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConceptoAFPMes]) REFERENCES [ERP].[ConceptoAFPMes] ([ID]),
    CONSTRAINT [FK__ConceptoA__IdAFP__4ACF8B8E] FOREIGN KEY ([IdAFP]) REFERENCES [ERP].[AFP] ([ID])
);

