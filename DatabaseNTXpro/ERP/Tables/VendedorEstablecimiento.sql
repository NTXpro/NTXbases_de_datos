CREATE TABLE [ERP].[VendedorEstablecimiento] (
    [ID]                INT           NOT NULL,
    [idVendedor]        INT           NULL,
    [idEstablecimiento] INT           NULL,
    [FechaRegistro]     DATETIME      NULL,
    [FechaEliminado]    DATETIME      NULL,
    [flagBorrador]      BIT           NULL,
    [flag]              BIT           NULL,
    [FechaModificado]   DATETIME      NULL,
    [UsuarioRegistro]   VARCHAR (250) NULL,
    [UsuarioModifico]   VARCHAR (250) NULL,
    [UsuarioElimino]    VARCHAR (250) NULL,
    [UsuarioActivo]     VARCHAR (250) NULL,
    [FechaActivacion]   DATETIME      NULL,
    CONSTRAINT [PK_VendedorEstablecimiento] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_VendedorEstablecimiento_Establecimiento] FOREIGN KEY ([idEstablecimiento]) REFERENCES [ERP].[Establecimiento] ([ID]),
    CONSTRAINT [FK_VendedorEstablecimiento_Vendedor] FOREIGN KEY ([idVendedor]) REFERENCES [ERP].[Vendedor] ([ID])
);

