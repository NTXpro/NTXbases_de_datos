CREATE TABLE [ERP].[PlanCuentaDestino] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [IdPlanCuentaOrigen]   INT             NULL,
    [IdPlanCuentaDestino1] INT             NULL,
    [IdPlanCuentaDestino2] INT             NULL,
    [Porcentaje]           DECIMAL (14, 5) NULL,
    [IdEmpresa]            INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdPlanCuentaDestino1]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    FOREIGN KEY ([IdPlanCuentaDestino2]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    FOREIGN KEY ([IdPlanCuentaOrigen]) REFERENCES [ERP].[PlanCuenta] ([ID])
);

