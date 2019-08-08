CREATE TABLE [ERP].[Gratificacion] (
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
    CONSTRAINT [PK__Gratific__3214EC27369E7BBA] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Gratifica__IdAni__2D3F28A7] FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID]),
    CONSTRAINT [FK__Gratifica__IdEmp__2C4B046E] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID])
);

