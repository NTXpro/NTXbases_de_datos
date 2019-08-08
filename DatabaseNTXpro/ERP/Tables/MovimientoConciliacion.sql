CREATE TABLE [ERP].[MovimientoConciliacion] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]          INT             NULL,
    [IdCuenta]           INT             NULL,
    [IdPeriodo]          INT             NULL,
    [Fecha]              DATETIME        NULL,
    [BancoSaldoAnterior] DECIMAL (14, 5) NULL,
    [BancoIngreso]       DECIMAL (14, 5) NULL,
    [BancoEgreso]        DECIMAL (14, 5) NULL,
    [BancoSaldo]         DECIMAL (14, 5) NULL,
    [ConciliadoIngreso]  DECIMAL (14, 5) NULL,
    [ConciliadoEgreso]   DECIMAL (14, 5) NULL,
    [DifiereIngreso]     DECIMAL (14, 5) NULL,
    [DifiereEgreso]      DECIMAL (14, 5) NULL,
    [LibroSaldoAnterior] DECIMAL (14, 5) NULL,
    [LibroIngreso]       DECIMAL (14, 5) NULL,
    [LibroEgreso]        DECIMAL (14, 5) NULL,
    [LibroSaldo]         DECIMAL (14, 5) NULL,
    [Flag]               BIT             NULL,
    [FlagConciliado]     BIT             NULL,
    [UsuarioRegistro]    VARCHAR (250)   NULL,
    CONSTRAINT [PK__Movimien__3214EC2740456D3C] PRIMARY KEY CLUSTERED ([ID] ASC)
);

