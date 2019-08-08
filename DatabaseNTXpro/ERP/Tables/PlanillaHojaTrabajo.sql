CREATE TABLE [ERP].[PlanillaHojaTrabajo] (
    [ID]                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdPlanillaCabecera] BIGINT          NULL,
    [IdConcepto]         INT             NULL,
    [HoraPorcentaje]     DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_PlanillaHojaTrabajo] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    CONSTRAINT [FK__PlanillaH__IdPla__65F88316] FOREIGN KEY ([IdPlanillaCabecera]) REFERENCES [ERP].[PlanillaCabecera] ([ID])
);

