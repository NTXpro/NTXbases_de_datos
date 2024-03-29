﻿CREATE TABLE [ERP].[SaldoInicial] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [IdProveedor]       INT             NULL,
    [IdTipoComprobante] INT             NULL,
    [Fecha]             DATETIME        NULL,
    [FechaVencimiento]  DATETIME        NULL,
    [FechaRecepcion]    DATETIME        NULL,
    [Serie]             VARCHAR (4)     NULL,
    [Documento]         VARCHAR (20)    NULL,
    [Monto]             DECIMAL (14, 6) NULL,
    [Flag]              BIT             NULL,
    [FlagBorrador]      BIT             NULL,
    [IdEmpresa]         INT             NULL,
    [TipoCambio]        DECIMAL (14, 6) NULL,
    [IdMoneda]          INT             NULL,
    [FechaRegistro]     DATETIME        NULL,
    [FechaActivacion]   DATETIME        NULL,
    [FechaEliminado]    DATETIME        NULL,
    [FechaModificado]   DATETIME        NULL,
    [UsuarioRegistro]   VARCHAR (250)   NULL,
    [UsuarioModifico]   VARCHAR (250)   NULL,
    [UsuarioActivo]     VARCHAR (250)   NULL,
    [UsuarioElimino]    VARCHAR (250)   NULL,
    CONSTRAINT [PK__SaldoIni__3214EC2799F6481F] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__SaldoInic__IdEmp__407B4EF6] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__SaldoInic__IdMon__4FBD9286] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__SaldoInic__IdPro__36F1E4BC] FOREIGN KEY ([IdProveedor]) REFERENCES [ERP].[Proveedor] ([ID]),
    CONSTRAINT [FK__SaldoInic__IdTip__37E608F5] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

