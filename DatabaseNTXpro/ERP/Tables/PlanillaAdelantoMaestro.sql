CREATE TABLE [ERP].[PlanillaAdelantoMaestro] (
    [Id]            INT      IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]     INT      NULL,
    [IdPlanilla]    INT      NULL,
    [FechaInicio]   DATETIME NULL,
    [FechaFin]      DATETIME NULL,
    [FechaCreacion] DATETIME NULL,
    CONSTRAINT [PK_PlanillaAdelantoMaestro] PRIMARY KEY CLUSTERED ([Id] ASC)
);

