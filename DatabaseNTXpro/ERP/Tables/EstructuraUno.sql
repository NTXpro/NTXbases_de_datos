CREATE TABLE [ERP].[EstructuraUno] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]       INT           NULL,
    [Tipo]            INT           NULL,
    [Nombre]          VARCHAR (200) NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [Flag]            BIT           NULL,
    CONSTRAINT [PK_EstructuraBalanceGeneralUno] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Estructur__IdEmp__487C6371] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Estructur__IdEmp__4C4CF455] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID])
);

