CREATE TABLE [ERP].[Chofer] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEntidad]       INT           NULL,
    [IdEmpresa]       INT           NULL,
    [Flag]            BIT           NULL,
    [FlagBorrador]    BIT           NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [Licencia]        VARCHAR (250) NULL,
    CONSTRAINT [PK__Chofer__3214EC273A0C6802] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Chofer__IdEmpres__725D8EA4] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Chofer__IdEntida__6B667852] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID])
);

