CREATE TABLE [ERP].[PlanillaPago] (
    [ID]                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdPlanillaCabecera] BIGINT          NULL,
    [IdConcepto]         INT             NULL,
    [SueldoMinimo]       DECIMAL (18, 2) NULL,
    [Calculo]            DECIMAL (18, 5) NULL,
    CONSTRAINT [PK_ERP.PlanillaPago] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__PlanillaP__IdCon__1A6C4B55] FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    CONSTRAINT [FK__PlanillaP__IdPla__65045EDD] FOREIGN KEY ([IdPlanillaCabecera]) REFERENCES [ERP].[PlanillaCabecera] ([ID])
);

