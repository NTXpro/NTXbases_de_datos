CREATE TABLE [ERP].[ListaPrecioDetalle] (
    [ID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdListaPrecio]       INT             NULL,
    [IdProducto]          INT             NULL,
    [PrecioUnitario]      DECIMAL (14, 5) NULL,
    [PorcentajeDescuento] INT             NULL,
    [FechaModificado]     DATETIME        NULL,
    [UsuarioRegistro]     VARCHAR (250)   NULL,
    [UsuarioModifico]     VARCHAR (250)   NULL,
    [UsuarioElimino]      VARCHAR (250)   NULL,
    [UsuarioActivo]       VARCHAR (250)   NULL,
    [FechaActivacion]     DATETIME        NULL,
    CONSTRAINT [PK__ListaPre__3214EC27C643AC30] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__ListaPrec__IdLis__58F12BAE] FOREIGN KEY ([IdListaPrecio]) REFERENCES [ERP].[ListaPrecio] ([ID]),
    CONSTRAINT [FK_ListaPrecioDetalle_Producto] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

