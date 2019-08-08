CREATE TABLE [ERP].[DatoLaboralSalud] (
    [ID]                         INT      IDENTITY (1, 1) NOT NULL,
    [IdRegimenSalud]             INT      NULL,
    [IdDatoLaboral]              INT      NULL,
    [IdEmpresa]                  INT      NULL,
    [FechaInicio]                DATETIME NULL,
    [FechaFin]                   DATETIME NULL,
    [IdEntidadPrestadoraDeSalud] INT      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdEntidadPrestadoraDeSalud]) REFERENCES [PLAME].[T14EntidadPrestadorasDeSalud] ([ID]),
    FOREIGN KEY ([IdRegimenSalud]) REFERENCES [PLAME].[T32RegimenSalud] ([ID])
);

