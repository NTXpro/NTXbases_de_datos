﻿CREATE TABLE [ERP].[AsientoDetalle] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdAsiento]            INT             NULL,
    [Orden]                INT             NULL,
    [IdPlanCuenta]         INT             NULL,
    [Nombre]               VARCHAR (250)   NULL,
    [IdDebeHaber]          INT             NULL,
    [IdProyecto]           INT             NULL,
    [Fecha]                DATETIME        NULL,
    [ImporteSoles]         DECIMAL (14, 5) NULL,
    [ImporteDolares]       DECIMAL (14, 5) NULL,
    [IdEntidad]            INT             NULL,
    [IdTipoComprobante]    INT             NULL,
    [Serie]                VARCHAR (50)    NULL,
    [Documento]            VARCHAR (50)    NULL,
    [FechaRegistro]        DATETIME        NULL,
    [FechaEliminado]       DATETIME        NULL,
    [FlagBorrador]         BIT             NULL,
    [Flag]                 BIT             NULL,
    [FechaModificado]      DATETIME        NULL,
    [UsuarioRegistro]      VARCHAR (250)   NULL,
    [UsuarioModifico]      VARCHAR (250)   NULL,
    [UsuarioElimino]       VARCHAR (250)   NULL,
    [UsuarioActivo]        VARCHAR (250)   NULL,
    [FechaActivacion]      DATETIME        NULL,
    [FlagAutomatico]       BIT             NULL,
    [IdentificadorProceso] VARCHAR (50)    NULL,
    CONSTRAINT [PK__AsientoD__3214EC272C157DAB] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__AsientoDe__IdDeb__743A1EC7] FOREIGN KEY ([IdDebeHaber]) REFERENCES [Maestro].[DebeHaber] ([ID]),
    CONSTRAINT [FK__AsientoDe__IdEnt__752E4300] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__AsientoDe__IdPla__7345FA8E] FOREIGN KEY ([IdPlanCuenta]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK__AsientoDe__IdTip__76226739] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID]),
    CONSTRAINT [FK_ASIENTO_ASIENTODETALLE] FOREIGN KEY ([IdAsiento]) REFERENCES [ERP].[Asiento] ([ID])
);

