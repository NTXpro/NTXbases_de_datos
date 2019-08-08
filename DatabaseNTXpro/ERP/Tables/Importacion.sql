﻿CREATE TABLE [ERP].[Importacion] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]           INT           NULL,
    [IdImportacionEstado] INT           NULL,
    [IdAlmacen]           INT           NULL,
    [IdMoneda]            INT           NULL,
    [IdProyecto]          INT           NULL,
    [IdVale]              INT           NULL,
    [FechaVale]           DATETIME      NULL,
    [Documento]           VARCHAR (10)  NULL,
    [Fecha]               DATETIME      NULL,
    [Observacion]         VARCHAR (250) NULL,
    [UsuarioRegistro]     VARCHAR (250) NULL,
    [FechaRegistro]       DATETIME      NULL,
    [UsuarioModifico]     VARCHAR (250) NULL,
    [FechaModificado]     DATETIME      NULL,
    [UsuarioActivo]       VARCHAR (250) NULL,
    [FechaActivacion]     DATETIME      NULL,
    [UsuarioElimino]      VARCHAR (250) NULL,
    [FechaEliminado]      DATETIME      NULL,
    [FlagBorrador]        BIT           NULL,
    [Flag]                BIT           NULL,
    CONSTRAINT [PK_Importacion] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdAlmacen]) REFERENCES [ERP].[Almacen] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    FOREIGN KEY ([IdImportacionEstado]) REFERENCES [Maestro].[ImportacionEstado] ([ID]),
    FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    FOREIGN KEY ([IdProyecto]) REFERENCES [ERP].[Proyecto] ([ID]),
    FOREIGN KEY ([IdVale]) REFERENCES [ERP].[Vale] ([ID])
);
