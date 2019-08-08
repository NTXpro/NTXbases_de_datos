CREATE TABLE [ERP].[PlanillaCabecera] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]            INT             NULL,
    [IdPeriodo]            INT             NULL,
    [IdPlanilla]           INT             NULL,
    [IdTrabajador]         INT             NULL,
    [FechaInicio]          DATETIME        NULL,
    [FechaFin]             DATETIME        NULL,
    [Orden]                INT             NULL,
    [CodigoProceso]        VARCHAR (200)   NULL,
    [TotalIngreso]         DECIMAL (18, 5) NULL,
    [TotalDescuentos]      DECIMAL (18, 5) NULL,
    [TotalAportes]         DECIMAL (18, 5) NULL,
    [NetoAPagar]           DECIMAL (18, 5) NULL,
    [IdDatoLaboralDetalle] INT             NULL,
    [FechaIniPlanilla]     DATETIME        NULL,
    [FechaFinPlanilla]     DATETIME        NULL,
    CONSTRAINT [PK_ERP.PlanillaCabecera] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__PlanillaC__IdEmp__1B606F8E] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__PlanillaC__IdPer__1C5493C7] FOREIGN KEY ([IdPeriodo]) REFERENCES [ERP].[Periodo] ([ID]),
    CONSTRAINT [FK__PlanillaC__IdPla__1D48B800] FOREIGN KEY ([IdPlanilla]) REFERENCES [Maestro].[Planilla] ([ID]),
    CONSTRAINT [FK__PlanillaC__IdTra__1E3CDC39] FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID])
);

