CREATE TABLE [ERP].[DatoLaboral] (
    [ID]                            INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]                     INT           NULL,
    [IdTrabajador]                  INT           NULL,
    [FechaInicio]                   DATETIME      NULL,
    [FechaCese]                     DATETIME      NULL,
    [FlagAsignacionFamiliar]        BIT           NULL,
    [FechaInicioAsignacionFamiliar] DATETIME      NULL,
    [FechaFinAsignacionFamiliar]    DATETIME      NULL,
    [UsuarioRegistro]               VARCHAR (250) NULL,
    [FechaRegistro]                 DATETIME      NULL,
    [UsuarioModifico]               VARCHAR (250) NULL,
    [FechaModifico]                 DATETIME      NULL,
    [IdMotivoCese]                  INT           NULL,
    CONSTRAINT [PK__DatoLabo__3214EC27B8F46947] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__DatoLabor__IdEmp__3C2C667C] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__DatoLabor__IdTra__3D208AB5] FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID])
);

