CREATE TABLE [ERP].[OrdenServicioDetalle] (
    [ID]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdOrdenServicio] INT             NULL,
    [IdProducto]      INT             NULL,
    [Nombre]          VARCHAR (250)   NULL,
    [FlagAfecto]      BIT             NULL,
    [Cantidad]        DECIMAL (14, 5) NULL,
    [PrecioUnitario]  DECIMAL (14, 5) NULL,
    [SubTotal]        DECIMAL (14, 5) NULL,
    [IGV]             DECIMAL (14, 5) NULL,
    [Total]           DECIMAL (14, 5) NULL,
    CONSTRAINT [PK__OrdenSer__3214EC272BB8B15C] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__OrdenServ__IdOrd__61DD0E18] FOREIGN KEY ([IdOrdenServicio]) REFERENCES [ERP].[OrdenServicio] ([ID]),
    CONSTRAINT [FK__OrdenServ__IdPro__60E8E9DF] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID])
);

