CREATE TABLE [ERP].[ValeDetalle_Copia] (
    [ID]                   BIGINT          NOT NULL,
    [IdProducto]           INT             NULL,
    [Nombre]               VARCHAR (250)   NULL,
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
    [Operacion]            VARCHAR (150)   NULL
);

