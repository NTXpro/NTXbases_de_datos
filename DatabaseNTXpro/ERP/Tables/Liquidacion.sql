CREATE TABLE [ERP].[Liquidacion] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]       INT           NULL,
    [IdPeriodo]       INT           NULL,
    [FechaInicio]     DATETIME      NULL,
    [FechaFin]        DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdPeriodo]) REFERENCES [ERP].[Periodo] ([ID])
);

