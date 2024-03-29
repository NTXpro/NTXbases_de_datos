﻿CREATE TABLE [ERP].[MovimientoCajaChica] (
    [ID]                            INT             IDENTITY (1, 1) NOT NULL,
    [Orden]                         INT             NULL,
    [TipoCambio]                    DECIMAL (14, 5) NULL,
    [IdCuenta]                      INT             NULL,
    [FechaEmision]                  DATETIME        NULL,
    [FechaCierre]                   DATETIME        NULL,
    [SaldoInicial]                  DECIMAL (14, 5) NULL,
    [TotalGastado]                  DECIMAL (14, 5) NULL,
    [IdEmpresa]                     INT             NULL,
    [FechaRegistro]                 DATETIME        NULL,
    [FechaModificado]               DATETIME        NULL,
    [UsuarioModifico]               VARCHAR (250)   NULL,
    [UsuarioRegistro]               VARCHAR (250)   NULL,
    [Flag]                          BIT             NULL,
    [FlagBorrador]                  BIT             NULL,
    [IdPeriodo]                     INT             NULL,
    [FlagCierre]                    BIT             NULL,
    [SaldoFinal]                    DECIMAL (14, 5) NULL,
    [Observacion]                   VARCHAR (250)   NULL,
    [Documento]                     VARCHAR (250)   NULL,
    [Saldo]                         DECIMAL (14, 5) NULL,
    [IdMovimientoTesoreriaGenerado] INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Movimient__IdCue__569F9A3F] FOREIGN KEY ([IdCuenta]) REFERENCES [ERP].[Cuenta] ([ID])
);

