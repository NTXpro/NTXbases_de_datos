CREATE TABLE [ERP].[ValeTransferenciaDetalle] (
    [ID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdProducto]          INT             NULL,
    [IdValeTransferencia] INT             NULL,
    [Nombre]              VARCHAR (250)   NULL,
    [FlagAfecto]          BIT             NULL,
    [Cantidad]            DECIMAL (14, 5) NULL,
    [PrecioUnitario]      DECIMAL (14, 5) NULL,
    [SubTotal]            DECIMAL (14, 5) NULL,
    [IGV]                 DECIMAL (14, 5) NULL,
    [Total]               DECIMAL (14, 5) NULL,
    [Fecha]               DATETIME        NULL,
    [NumeroLote]          VARCHAR (20)    NULL,
    CONSTRAINT [PK__ValeTran__3214EC274573035C] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__ValeTrans__IdPro__7FD78553] FOREIGN KEY ([IdProducto]) REFERENCES [ERP].[Producto] ([ID]),
    CONSTRAINT [FK__ValeTrans__IdVal__00CBA98C] FOREIGN KEY ([IdValeTransferencia]) REFERENCES [ERP].[ValeTransferencia] ([ID])
);

