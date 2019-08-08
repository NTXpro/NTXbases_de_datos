﻿CREATE TABLE [ERP].[AnticipoCompra] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [IdProveedor]       INT             NULL,
    [IdTipoComprobante] INT             NULL,
    [IdMoneda]          INT             NULL,
    [IdEmpresa]         INT             NULL,
    [IdPeriodo]         INT             NULL,
    [Serie]             VARCHAR (10)    NULL,
    [Documento]         VARCHAR (20)    NULL,
    [TipoCambio]        DECIMAL (14, 5) NULL,
    [Orden]             INT             NULL,
    [FechaEmision]      DATETIME        NULL,
    [Descripcion]       VARCHAR (250)   NULL,
    [Total]             DECIMAL (14, 5) NULL,
    [Flag]              BIT             NULL,
    [FlagBorrador]      BIT             NULL,
    [UsuarioRegistro]   VARCHAR (250)   NULL,
    [UsuarioModifico]   VARCHAR (250)   NULL,
    [UsuarioElimino]    VARCHAR (250)   NULL,
    [UsuarioActivo]     VARCHAR (250)   NULL,
    [FechaRegistro]     DATETIME        NULL,
    [FechaModificado]   DATETIME        NULL,
    [FechaActivacion]   DATETIME        NULL,
    [FechaEliminado]    DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);
