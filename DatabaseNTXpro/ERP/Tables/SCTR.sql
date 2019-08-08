CREATE TABLE [ERP].[SCTR] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [IdDatoLaboral] INT      NULL,
    [IdEmpresa]     INT      NULL,
    [IdPension]     INT      NULL,
    [IdSalud]       INT      NULL,
    [FechaInicio]   DATETIME NULL,
    [FechaFin]      DATETIME NULL,
    [IdTipoSalud]   INT      NULL,
    [IdTipoPension] INT      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdPension]) REFERENCES [Maestro].[TipoPension] ([ID]),
    FOREIGN KEY ([IdSalud]) REFERENCES [Maestro].[TipoSalud] ([ID]),
    FOREIGN KEY ([IdTipoPension]) REFERENCES [Maestro].[TipoPension] ([ID]),
    FOREIGN KEY ([IdTipoSalud]) REFERENCES [Maestro].[TipoSalud] ([ID])
);

