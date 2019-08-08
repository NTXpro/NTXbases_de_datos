CREATE TABLE [ERP].[ComparadorDetalle] (
    [ID]           INT             IDENTITY (1, 1) NOT NULL,
    [IdComparador] INT             NULL,
    [IdProducto]   INT             NULL,
    [IdProveedor]  INT             NULL,
    [Cantidad]     INT             NULL,
    [Precio]       DECIMAL (14, 5) NULL,
    [Total]        DECIMAL (14, 5) NULL,
    [Seleccionado] BIT             NULL,
    CONSTRAINT [PK__Comparad__3214EC27AA6B237B] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Comparado__IdCom__4DB6E531] FOREIGN KEY ([IdComparador]) REFERENCES [ERP].[Comparador] ([ID]),
    CONSTRAINT [FK__Comparado__IdPro__4EAB096A] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID]),
    CONSTRAINT [FK__Comparado__IdPro__4F9F2DA3] FOREIGN KEY ([IdProveedor]) REFERENCES [ERP].[Proveedor] ([ID])
);

