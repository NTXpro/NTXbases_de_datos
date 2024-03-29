﻿CREATE TABLE [ERP].[Producto] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]          INT             NULL,
    [Nombre]             VARCHAR (250)   NULL,
    [Peso]               DECIMAL (14, 5) NULL,
    [IdUnidadMedida]     INT             NULL,
    [IdTipoProducto]     INT             NULL,
    [IdExistencia]       INT             NULL,
    [IdMarca]            INT             NULL,
    [FechaRegistro]      DATETIME        NULL,
    [FechaEliminado]     DATETIME        NULL,
    [FlagBorrador]       BIT             NULL,
    [Flag]               BIT             NULL,
    [IdPlanCuenta]       INT             NULL,
    [IdPlanCuentaCompra] INT             NULL,
    [FlagISC]            BIT             NULL,
    [FlagOtrosImpuesto]  BIT             NULL,
    [CodigoReferencia]   VARCHAR (50)    NULL,
    [FechaModificado]    DATETIME        NULL,
    [UsuarioRegistro]    VARCHAR (250)   NULL,
    [UsuarioModifico]    VARCHAR (250)   NULL,
    [UsuarioElimino]     VARCHAR (250)   NULL,
    [UsuarioActivo]      VARCHAR (250)   NULL,
    [FechaActivacion]    DATETIME        NULL,
    [FlagIGVAfecto]      BIT             NULL,
    [Imagen]             VARBINARY (MAX) NULL,
    [NombreImagen]       VARCHAR (200)   NULL,
    [StockMinimo]        DECIMAL (14, 5) NULL,
    [StockIdeal]         DECIMAL (14, 5) NULL,
    [StockMaximo]        DECIMAL (14, 5) NULL,
    [StockDeseable]      DECIMAL (14, 5) NULL,
    CONSTRAINT [PK__Producto__3214EC274F19025A] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Producto__IdEmpr__56D3D912] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Producto__IdExis__69B1A35C] FOREIGN KEY ([IdExistencia]) REFERENCES [PLE].[T5Existencia] ([ID]),
    CONSTRAINT [FK__Producto__IdMarc__664B26CC] FOREIGN KEY ([IdMarca]) REFERENCES [Maestro].[Marca] ([ID]),
    CONSTRAINT [FK__Producto__IdPlan__407C1A4D] FOREIGN KEY ([IdPlanCuentaCompra]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK__Producto__IdPlan__6541F3FA] FOREIGN KEY ([IdPlanCuenta]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK__Producto__IdTipo__6462DE5A] FOREIGN KEY ([IdTipoProducto]) REFERENCES [Maestro].[TipoProducto] ([ID]),
    CONSTRAINT [FK__Producto__IdUnid__636EBA21] FOREIGN KEY ([IdUnidadMedida]) REFERENCES [PLE].[T6UnidadMedida] ([ID])
);

