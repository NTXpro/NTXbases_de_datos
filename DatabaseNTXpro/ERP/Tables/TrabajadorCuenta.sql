CREATE TABLE [ERP].[TrabajadorCuenta] (
    [ID]                        INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]                 INT           NOT NULL,
    [IdTrabajador]              INT           NOT NULL,
    [IdBanco]                   INT           NOT NULL,
    [IdTipoCuenta]              INT           NOT NULL,
    [Fecha]                     DATETIME      NULL,
    [NumeroCuenta]              VARCHAR (50)  NULL,
    [NumeroCuentaInterbancario] VARCHAR (50)  NULL,
    [FechaRegistro]             DATETIME      NULL,
    [UsuarioRegistro]           VARCHAR (250) NULL,
    [FechaModificado]           DATETIME      NULL,
    [UsuarioModifico]           VARCHAR (250) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdBanco]) REFERENCES [PLE].[T3Banco] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdTipoCuenta]) REFERENCES [Maestro].[TipoCuenta] ([ID]),
    FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID])
);

