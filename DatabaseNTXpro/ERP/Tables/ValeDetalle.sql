CREATE TABLE [ERP].[ValeDetalle] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdProducto]           INT             NULL,
    [Nombre]               VARCHAR (MAX)   NULL,
    [FlagAfecto]           BIT             NULL,
    [Cantidad]             DECIMAL (14, 5) NULL,
    [PrecioUnitario]       DECIMAL (14, 5) NULL,
    [SubTotal]             DECIMAL (14, 5) NULL,
    [IGV]                  DECIMAL (14, 5) NULL,
    [Total]                DECIMAL (14, 5) NULL,
    [IdVale]               INT             NULL,
    [Fecha]                DATETIME        NULL,
    [NumeroLote]           VARCHAR (20)    NULL,
    [Item]                 INT             NULL,
    [PrecioPromedio]       DECIMAL (14, 5) NULL,
    [SubtotalPromedio]     DECIMAL (14, 5) NULL,
    [TotalPromedio]        DECIMAL (14, 5) NULL,
    [PrecioUnitarioPrueba] DECIMAL (20, 8) NULL,
    [NroDocumentoPrueba]   VARCHAR (50)    NULL,
    [Operacion]            VARCHAR (150)   NULL,
    CONSTRAINT [PK__ValeDeta__3214EC279E17E768] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__ValeDetal__IdPro__08B6E417] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

