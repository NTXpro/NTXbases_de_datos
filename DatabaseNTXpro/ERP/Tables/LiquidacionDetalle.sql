﻿CREATE TABLE [ERP].[LiquidacionDetalle] (
    [ID]                              INT             IDENTITY (1, 1) NOT NULL,
    [IdLiquidacion]                   INT             NULL,
    [IdDatoLaboral]                   INT             NULL,
    [Sueldo]                          DECIMAL (14, 5) NULL,
    [CTSTrunca]                       DECIMAL (14, 5) NULL,
    [VacacionTrunca]                  DECIMAL (14, 5) NULL,
    [GratificacionTrunca]             DECIMAL (14, 5) NULL,
    [OtroIngreso]                     DECIMAL (14, 5) NULL,
    [Descuento]                       DECIMAL (14, 5) NULL,
    [OtroDescuento]                   DECIMAL (14, 5) NULL,
    [Aportacion]                      DECIMAL (14, 5) NULL,
    [TotalLiquidacion]                DECIMAL (14, 5) NULL,
    [FechaInicioGratificacion]        DATETIME        NULL,
    [FechaFinGratificacion]           DATETIME        NULL,
    [AsignacionFamiliarGratificacion] DECIMAL (14, 5) NULL,
    [BonificacionGratificacion]       DECIMAL (14, 5) NULL,
    [ComisionGratificacion]           DECIMAL (14, 5) NULL,
    [HE25Gratificacion]               DECIMAL (14, 5) NULL,
    [HE35Gratificacion]               DECIMAL (14, 5) NULL,
    [HE100Gratificacion]              DECIMAL (14, 5) NULL,
    [MesGratificacion]                INT             NULL,
    [DiaGratificacion]                INT             NULL,
    [FechaInicioVacacion]             DATETIME        NULL,
    [FechaFinVacacion]                DATETIME        NULL,
    [AsignacionFamiliarVacacion]      DECIMAL (14, 5) NULL,
    [BonificacionVacacion]            DECIMAL (14, 5) NULL,
    [ComisionVacacion]                DECIMAL (14, 5) NULL,
    [HE25Vacacion]                    DECIMAL (14, 5) NULL,
    [HE35Vacacion]                    DECIMAL (14, 5) NULL,
    [HE100Vacacion]                   DECIMAL (14, 5) NULL,
    [FechaInicioCTS]                  DATETIME        NULL,
    [FechaFinCTS]                     DATETIME        NULL,
    [AsignacionFamiliarCTS]           DECIMAL (14, 5) NULL,
    [BonificacionCTS]                 DECIMAL (14, 5) NULL,
    [ComisionCTS]                     DECIMAL (14, 5) NULL,
    [HE25CTS]                         DECIMAL (14, 5) NULL,
    [HE35CTS]                         DECIMAL (14, 5) NULL,
    [HE100CTS]                        DECIMAL (14, 5) NULL,
    [MesCTS]                          INT             NULL,
    [DiaCTS]                          INT             NULL,
    CONSTRAINT [PK__Liquidac__3214EC27526580B0] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Liquidaci__IdDat__1FB0235F] FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    CONSTRAINT [FK__Liquidaci__IdLiq__1EBBFF26] FOREIGN KEY ([IdLiquidacion]) REFERENCES [ERP].[Liquidacion] ([ID])
);

