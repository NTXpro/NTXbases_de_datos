CREATE TABLE [ERP].[ImportacionProductoDetalle] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [Item]                 INT             NULL,
    [IdImportacion]        INT             NULL,
    [IdOrdenCompra]        INT             NULL,
    [IdProducto]           INT             NULL,
    [Fecha]                DATETIME        NULL,
    [Lote]                 VARCHAR (50)    NULL,
    [Cantidad]             DECIMAL (18, 5) NULL,
    [PrecioUnitario]       DECIMAL (18, 5) NULL,
    [Total]                DECIMAL (18, 5) NULL,
    [PrecioUnitarioCosteo] DECIMAL (18, 5) NULL,
    [TotalCosteo]          DECIMAL (18, 5) NULL,
    CONSTRAINT [PK_ImportacionProducto] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdImportacion]) REFERENCES [ERP].[Importacion] ([ID]),
    FOREIGN KEY ([IdOrdenCompra]) REFERENCES [ERP].[OrdenCompra] ([ID]),
    CONSTRAINT [FK__Importaci__IdPro__1646B4B6] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

