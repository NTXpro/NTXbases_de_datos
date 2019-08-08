CREATE TABLE [ERP].[RequerimientoDetalle] (
    [ID]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdRequerimiento] INT             NULL,
    [IdProducto]      INT             NULL,
    [Nombre]          VARCHAR (MAX)   NULL,
    [Cantidad]        DECIMAL (14, 5) NULL,
    CONSTRAINT [PK__Requerim__3214EC27FBD1A04D] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Requerimi__IdReq__3DD4B7CC] FOREIGN KEY ([IdRequerimiento]) REFERENCES [ERP].[Requerimiento] ([ID])
);

