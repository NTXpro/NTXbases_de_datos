CREATE TABLE [ERP].[RecetaProductoDetalle] (
    [ID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdReceta]   INT             NULL,
    [IdProducto] INT             NULL,
    [Cantidad]   DECIMAL (18, 5) NULL,
    CONSTRAINT [PK_RecetaDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_RecetaDetalle_Receta] FOREIGN KEY ([IdReceta]) REFERENCES [ERP].[Receta] ([ID]),
    CONSTRAINT [FK_RecetaProductoDetalle_Producto] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

