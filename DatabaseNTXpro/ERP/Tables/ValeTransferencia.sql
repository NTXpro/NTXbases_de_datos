﻿CREATE TABLE [ERP].[ValeTransferencia] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]        INT             NULL,
    [IdAlmacenOrigen]  INT             NULL,
    [IdAlmacenDestino] INT             NULL,
    [Fecha]            DATETIME        NULL,
    [Documento]        VARCHAR (8)     NULL,
    [Observacion]      VARCHAR (250)   NULL,
    [SubTotal]         DECIMAL (14, 5) NULL,
    [IGV]              DECIMAL (14, 5) NULL,
    [Total]            DECIMAL (14, 5) NULL,
    [Flag]             BIT             NULL,
    [FlagBorrador]     BIT             NULL,
    [FechaRegistro]    DATETIME        NULL,
    [UsuarioRegistro]  VARCHAR (250)   NULL,
    [UsuarioModifico]  VARCHAR (250)   NULL,
    [FechaModificado]  DATETIME        NULL,
    [UsuarioElimino]   VARCHAR (250)   NULL,
    [FechaEliminado]   DATETIME        NULL,
    [UsuarioActivo]    VARCHAR (250)   NULL,
    [FechaActivacion]  DATETIME        NULL,
    [IdMoneda]         INT             NULL,
    [TipoCambio]       DECIMAL (14, 5) NULL,
    [PorcentajeIGV]    DECIMAL (14, 5) NULL,
    [IdValeOrigen]     INT             NULL,
    [IdValeDestino]    INT             NULL,
    CONSTRAINT [PK__ValeTran__3214EC27D11C113B] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__ValeTrans__IdAlm__7C06F46F] FOREIGN KEY ([IdAlmacenOrigen]) REFERENCES [ERP].[Almacen] ([ID]),
    CONSTRAINT [FK__ValeTrans__IdAlm__7CFB18A8] FOREIGN KEY ([IdAlmacenDestino]) REFERENCES [ERP].[Almacen] ([ID])
);

