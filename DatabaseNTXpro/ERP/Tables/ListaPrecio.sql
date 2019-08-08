CREATE TABLE [ERP].[ListaPrecio] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]           INT           NULL,
    [Nombre]              VARCHAR (50)  NULL,
    [IdMoneda]            INT           NULL,
    [PorcentajeDescuento] INT           NULL,
    [FechaRegistro]       DATETIME      NULL,
    [FechaEliminado]      DATETIME      NULL,
    [FlagBorrador]        BIT           NULL,
    [Flag]                BIT           NULL,
    [FlagPrincipal]       BIT           NULL,
    [FechaModificado]     DATETIME      NULL,
    [UsuarioRegistro]     VARCHAR (250) NULL,
    [UsuarioModifico]     VARCHAR (250) NULL,
    [UsuarioElimino]      VARCHAR (250) NULL,
    [UsuarioActivo]       VARCHAR (250) NULL,
    [FechaActivacion]     DATETIME      NULL,
    CONSTRAINT [PK__ListaPre__3214EC27E6A9AE64] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ListaPrecio_Moneda] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID])
);

