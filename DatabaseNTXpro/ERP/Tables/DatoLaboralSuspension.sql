CREATE TABLE [ERP].[DatoLaboralSuspension] (
    [ID]               INT          IDENTITY (1, 1) NOT NULL,
    [IdTipoSuspension] INT          NULL,
    [IdDatoLaboral]    INT          NULL,
    [IdEmpresa]        INT          NULL,
    [FechaInicio]      DATETIME     NULL,
    [FechaFin]         DATETIME     NULL,
    [CITT]             VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdTipoSuspension]) REFERENCES [PLAME].[T21TipoSuspension] ([ID])
);

