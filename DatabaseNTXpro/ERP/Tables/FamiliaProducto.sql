CREATE TABLE [ERP].[FamiliaProducto] (
    [ID]         INT IDENTITY (1, 1) NOT NULL,
    [IdFamilia]  INT NULL,
    [IdProducto] INT NULL,
    [IdEmpresa]  INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__FamiliaPr__IdFam__0F63E1A6] FOREIGN KEY ([IdFamilia]) REFERENCES [ERP].[Familia] ([ID]),
    CONSTRAINT [FK__FamiliaPr__IdPro__169AEF1A] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

