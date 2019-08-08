CREATE TABLE [ERP].[TransformacionDestinoDetalle] (
    [ID]               BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdTransformacion] INT             NULL,
    [IdProducto]       INT             NULL,
    [Fecha]            DATETIME        NULL,
    [Lote]             VARCHAR (50)    NULL,
    [FlagAfecto]       BIT             NULL,
    [Cantidad]         DECIMAL (18, 5) NULL,
    [PrecioUnitario]   DECIMAL (18, 5) NULL,
    [SubTotal]         DECIMAL (18, 5) NULL,
    [IGV]              DECIMAL (18, 5) NULL,
    [Total]            DECIMAL (18, 5) NULL,
    CONSTRAINT [PK__Transfor__3214EC27CE2E61C2] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Transform__IdPro__11C12B64] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID]),
    CONSTRAINT [FK__Transform__IdTra__10CD072B] FOREIGN KEY ([IdTransformacion]) REFERENCES [ERP].[Transformacion] ([ID])
);

