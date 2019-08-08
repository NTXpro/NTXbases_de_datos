CREATE TABLE [ERP].[Destino] (
    [ID]                   INT           NOT NULL,
    [IdPlanCuenta]         INT           NULL,
    [IdPlanCuentaDestino1] INT           NULL,
    [IdPlanCuentaDestino2] INT           NULL,
    [Porcentaje]           INT           NULL,
    [FechaModificado]      DATETIME      NULL,
    [UsuarioRegistro]      VARCHAR (250) NULL,
    [UsuarioModifico]      VARCHAR (250) NULL,
    [UsuarioElimino]       VARCHAR (250) NULL,
    [UsuarioActivo]        VARCHAR (250) NULL,
    [FechaActivacion]      DATETIME      NULL,
    CONSTRAINT [PK_Destino] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Destino_PlanCuenta] FOREIGN KEY ([IdPlanCuenta]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK_Destino_PlanCuenta1] FOREIGN KEY ([IdPlanCuentaDestino1]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK_Destino_PlanCuenta2] FOREIGN KEY ([IdPlanCuentaDestino2]) REFERENCES [ERP].[PlanCuenta] ([ID])
);

