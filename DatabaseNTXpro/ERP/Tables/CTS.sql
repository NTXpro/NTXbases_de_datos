CREATE TABLE [ERP].[CTS] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]       INT           NOT NULL,
    [IdAnio]          INT           NOT NULL,
    [IdFecha]         INT           NULL,
    [FechaInicio]     DATETIME      NULL,
    [FechaFin]        DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    CONSTRAINT [PK__CTS__3214EC276A446890] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__CTS__IdAnio__658381CA] FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID]),
    CONSTRAINT [FK__CTS__IdEmpresa__6677A603] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID])
);

