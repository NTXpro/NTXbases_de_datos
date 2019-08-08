CREATE TABLE [ERP].[PeriodoSistema] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdSistema]       INT           NULL,
    [IdPeriodo]       INT           NULL,
    [IdEmpresa]       INT           NULL,
    [FlagCierre]      BIT           NULL,
    [Fecha]           DATETIME      NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_PeriodoSistema] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PeriodoSistema_Empresa] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK_PeriodoSistema_Sistema] FOREIGN KEY ([IdSistema]) REFERENCES [Seguridad].[Sistema] ([ID])
);

