CREATE TABLE [ERP].[Contrato] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [IdDatoLaboral]  INT           NULL,
    [IdEmpresa]      INT           NULL,
    [IdTipoContrato] INT           NULL,
    [FechaInicio]    DATETIME      NULL,
    [FechaFin]       DATETIME      NULL,
    [Adjunto]        VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdTipoContrato]) REFERENCES [PLAME].[T12TipoContrato] ([ID])
);

