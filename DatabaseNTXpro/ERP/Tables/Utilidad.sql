CREATE TABLE [ERP].[Utilidad] (
    [ID]                                 INT             IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]                          INT             NULL,
    [IdAnioProcesado]                    INT             NOT NULL,
    [IdPeriodoTrabajado]                 INT             NULL,
    [RentaAnual]                         DECIMAL (14, 5) NULL,
    [PorcentajeDistribuir]               DECIMAL (14, 5) NULL,
    [UtilidadDistribuir]                 DECIMAL (14, 5) NULL,
    [IdTipoPago]                         INT             NULL,
    [PorcentajeDiaTrabajado]             DECIMAL (14, 5) NULL,
    [PorcentajeRemuneracionPercibida]    DECIMAL (14, 5) NULL,
    [TotalDiasTrabajados]                DECIMAL (14, 5) NULL,
    [TotalRemuneracionPercibida]         DECIMAL (14, 5) NULL,
    [TotalUtilidadDiasTrabajados]        DECIMAL (14, 5) NULL,
    [TotalUtilidadRemuneracionPercibida] DECIMAL (14, 5) NULL,
    [TotalUtilidad]                      DECIMAL (14, 5) NULL,
    [UsuarioRegistro]                    VARCHAR (250)   NULL,
    [FechaRegistro]                      DATETIME        NULL,
    CONSTRAINT [PK__Utilidad__3214EC276E35B4BF] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Utilidad__IdAnio__17A4ED43] FOREIGN KEY ([IdAnioProcesado]) REFERENCES [Maestro].[Anio] ([ID]),
    CONSTRAINT [FK__Utilidad__IdPeri__1899117C] FOREIGN KEY ([IdPeriodoTrabajado]) REFERENCES [ERP].[Periodo] ([ID])
);

