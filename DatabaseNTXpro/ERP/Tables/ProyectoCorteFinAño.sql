﻿CREATE TABLE [ERP].[ProyectoCorteFinAño] (
    [ID]                  INT             NOT NULL,
    [Numero]              VARCHAR (10)    NOT NULL,
    [IdMoneda]            INT             NULL,
    [PresupuestoVenta]    DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_PresupuestoVenta] DEFAULT ((0)) NOT NULL,
    [IgvVenta]            DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_IgvVenta] DEFAULT ((0)) NOT NULL,
    [TotalVenta]          DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_TotalVenta] DEFAULT ((0)) NOT NULL,
    [PresupuestoCompra]   DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_PresupuestoCompra] DEFAULT ((0)) NOT NULL,
    [IgvCompra]           DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_IgvCompra] DEFAULT ((0)) NOT NULL,
    [TotalCompra]         DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_TotalCompra] DEFAULT ((0)) NOT NULL,
    [Utilidad]            DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_Utilidad] DEFAULT ((0)) NOT NULL,
    [IgvUtilidad]         DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_IgvUtilidad] DEFAULT ((0)) NOT NULL,
    [TotalUtilidad]       DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_TotalUtilidad] DEFAULT ((0)) NOT NULL,
    [PorcentajeUtilidad]  DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_PorcentajeUtilidad] DEFAULT ((0)) NOT NULL,
    [Igv]                 DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_Igv] DEFAULT ((0)) NOT NULL,
    [FechaCorte]          DATETIME        NULL,
    [PresupuestoCompraM]  DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_PresupuestoCompraM] DEFAULT ((0)) NOT NULL,
    [IgvCompraM]          DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_IgvCompraM] DEFAULT ((0)) NOT NULL,
    [TotalCompraM]        DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_TotalCompraM] DEFAULT ((0)) NOT NULL,
    [UtilidadM]           DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_UtilidadM] DEFAULT ((0)) NOT NULL,
    [IgvUtilidadM]        DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_IgvUtilidadM] DEFAULT ((0)) NOT NULL,
    [TotalUtilidadM]      DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_TotalUtilidadM] DEFAULT ((0)) NOT NULL,
    [PorcentajeUtilidadM] DECIMAL (14, 5) CONSTRAINT [DF_ProyectoCorte_PorcentajeUtilidadM] DEFAULT ((0)) NOT NULL,
    [IdEmpresa]           INT             NOT NULL
);

