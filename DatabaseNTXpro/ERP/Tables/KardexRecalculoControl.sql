CREATE TABLE [ERP].[KardexRecalculoControl] (
    [ROWid]            INT             NOT NULL,
    [IDmaestro]        INT             NULL,
    [Fecha]            DATETIME        NULL,
    [IdTipoMovimiento] INT             NULL,
    [FlagCostear]      INT             NULL,
    [IDdetalle]        INT             NULL,
    [IdProducto]       INT             NULL,
    [Nombre]           VARCHAR (250)   NULL,
    [Cantidad]         DECIMAL (14, 5) NULL,
    [SubTotal]         DECIMAL (14, 5) NULL,
    [PrecioUnitario]   DECIMAL (14, 5) NULL,
    [IdMoneda]         INT             NULL,
    [TipoCambio]       DECIMAL (14, 5) NULL,
    [CalculadoPU]      DECIMAL (14, 5) NULL,
    [CalculadoPP]      DECIMAL (14, 5) NULL,
    [AcumuladoCant]    DECIMAL (14, 5) NULL,
    [AcumuladoSaldo]   DECIMAL (14, 5) NULL,
    [IdConcepto]       INT             NULL,
    [IdAlmacen]        INT             NULL,
    [IdProyecto]       INT             NULL,
    CONSTRAINT [PK_KardexRecalculoControl] PRIMARY KEY CLUSTERED ([ROWid] ASC)
);

