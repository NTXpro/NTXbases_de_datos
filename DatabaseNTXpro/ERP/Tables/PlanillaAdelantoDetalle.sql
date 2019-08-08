CREATE TABLE [ERP].[PlanillaAdelantoDetalle] (
    [Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [IdAdelanto]         INT             NULL,
    [IdPlanillaCabecera] INT             NULL,
    [Monto]              DECIMAL (18, 5) NULL,
    CONSTRAINT [PK_PlanillaAdelantoDetalle] PRIMARY KEY CLUSTERED ([Id] ASC)
);

