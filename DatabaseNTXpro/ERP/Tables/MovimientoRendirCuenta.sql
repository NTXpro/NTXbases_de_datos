CREATE TABLE [ERP].[MovimientoRendirCuenta] (
    [ID]                            INT             IDENTITY (1, 1) NOT NULL,
    [IdMovimientoTesoreria]         INT             NULL,
    [Orden]                         INT             NULL,
    [Total]                         DECIMAL (14, 5) NULL,
    [ToTalGastado]                  DECIMAL (14, 5) NULL,
    [Flag]                          BIT             NULL,
    [FlagBorrador]                  BIT             NULL,
    [IdPeriodo]                     INT             NULL,
    [IdEmpresa]                     INT             NULL,
    [FechaRegistro]                 DATETIME        NULL,
    [FechaModificado]               DATETIME        NULL,
    [UsuarioModifico]               VARCHAR (250)   NULL,
    [UsuarioRegistro]               VARCHAR (250)   NULL,
    [FlagCierre]                    BIT             NULL,
    [FechaCierre]                   DATETIME        NULL,
    [TipoCambio]                    DECIMAL (14, 5) NULL,
    [FechaEmision]                  DATETIME        NULL,
    [IdMovimientoTesoreriaGenerado] INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

