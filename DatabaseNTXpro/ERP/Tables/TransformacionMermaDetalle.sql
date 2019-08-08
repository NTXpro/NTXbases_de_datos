CREATE TABLE [ERP].[TransformacionMermaDetalle] (
    [ID]               BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdTransformacion] INT             NULL,
    [IdProducto]       INT             NULL,
    [Lote]             VARCHAR (50)    NULL,
    [FlagAfecto]       BIT             NULL,
    [Cantidad]         DECIMAL (18, 5) NULL,
    [PrecioUnitario]   DECIMAL (18, 5) NULL,
    [SubTotal]         DECIMAL (18, 5) NULL,
    [IGV]              DECIMAL (18, 5) NULL,
    [Total]            DECIMAL (18, 5) NULL,
    CONSTRAINT [PK__Transfor__3214EC279559A9F2] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Transform__IdPro__0DF09A80] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID]),
    CONSTRAINT [FK__Transform__IdTra__0CFC7647] FOREIGN KEY ([IdTransformacion]) REFERENCES [ERP].[Transformacion] ([ID])
);

