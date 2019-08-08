CREATE TABLE [ERP].[Periodo] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdAnio]          INT           NULL,
    [IdMes]           INT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_Periodo] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PeriodoAnio] FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID]),
    CONSTRAINT [FK_PeriodoMes] FOREIGN KEY ([IdMes]) REFERENCES [Maestro].[Mes] ([ID])
);

