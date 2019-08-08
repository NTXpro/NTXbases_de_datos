CREATE TABLE [ERP].[Trabajador] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [IdEntidad]       INT             NOT NULL,
    [IdEmpresa]       INT             NOT NULL,
    [NombreImagen]    VARCHAR (500)   NULL,
    [Imagen]          VARBINARY (MAX) NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [FechaRegistro]   DATETIME        NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [FechaModificado] DATETIME        NULL,
    [UsuarioElimino]  VARCHAR (250)   NULL,
    [FechaEliminado]  DATETIME        NULL,
    [UsuarioActivo]   VARCHAR (250)   NULL,
    [FechaActivacion] DATETIME        NULL,
    [FlagBorrador]    BIT             NULL,
    [Flag]            BIT             NULL,
    CONSTRAINT [PK_Trabajador] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Trabajado__IdEmp__2FEF161B] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Trabajado__IdEnt__2EFAF1E2] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID])
);

