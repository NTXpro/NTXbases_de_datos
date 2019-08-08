﻿CREATE TABLE [ERP].[Asiento] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [Nombre]               VARCHAR (255)   NULL,
    [Orden]                INT             NULL,
    [Fecha]                DATETIME        NULL,
    [IdEmpresa]            INT             NULL,
    [IdPeriodo]            INT             NULL,
    [IdOrigen]             INT             NULL,
    [IdMoneda]             INT             NULL,
    [TipoCambio]           DECIMAL (14, 5) NULL,
    [UsuarioRegistro]      VARCHAR (250)   NULL,
    [FechaRegistro]        DATETIME        NULL,
    [UsuarioModifico]      VARCHAR (250)   NULL,
    [FechaModificado]      DATETIME        NULL,
    [UsuarioActivo]        VARCHAR (250)   NULL,
    [FechaActivacion]      DATETIME        NULL,
    [UsuarioElimino]       VARCHAR (250)   NULL,
    [FechaEliminado]       DATETIME        NULL,
    [FlagEditar]           BIT             NULL,
    [FlagBorrador]         BIT             NULL,
    [Flag]                 BIT             NULL,
    [IdentificadorProceso] VARCHAR (50)    NULL,
    [Referencia]           VARCHAR (50)    NULL,
    CONSTRAINT [PK__Asiento__3214EC2780F11573] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Asiento__IdEmpre__6BA4D8C6] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Asiento__IdMoned__6E814571] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__Asiento__IdOrige__6D8D2138] FOREIGN KEY ([IdOrigen]) REFERENCES [Maestro].[Origen] ([ID])
);

