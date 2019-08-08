CREATE TABLE [ERP].[ProductoPropiedad] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [IdProducto]  INT          NULL,
    [IdPropiedad] INT          NULL,
    [Valor]       VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdPropiedad]) REFERENCES [Maestro].[Propiedad] ([ID]),
    CONSTRAINT [FK__ProductoP__IdPro__778C5815] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

