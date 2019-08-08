CREATE TABLE [ERP].[EstructuraTres] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEstructuraDos] INT           NULL,
    [Nombre]          VARCHAR (200) NULL,
    [Orden]           INT           NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [Flag]            BIT           NULL,
    CONSTRAINT [PK__Estructu__3214EC27474529C8] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Estructur__IdEst__365DB336] FOREIGN KEY ([IdEstructuraDos]) REFERENCES [ERP].[EstructuraDos] ([ID])
);

