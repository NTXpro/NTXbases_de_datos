CREATE TABLE [ERP].[Vendedor] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdTrabajador]    INT           NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaELiminado]  DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK__Vendedor__3214EC273CEA4D90] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Vendedor__IdTrab__49AEE81E] FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID])
);

