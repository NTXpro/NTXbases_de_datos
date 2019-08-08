﻿CREATE TABLE [ERP].[Operacion] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]           VARCHAR (50)  NULL,
    [Descripcion]      VARCHAR (250) NULL,
    [IdTipoMovimiento] INT           NULL,
    [IdPlanCuenta]     INT           NULL,
    [IdEmpresa]        INT           NULL,
    [IdAnio]           INT           NULL,
    [FechaModificado]  DATETIME      NULL,
    [UsuarioRegistro]  VARCHAR (250) NULL,
    [UsuarioModifico]  VARCHAR (250) NULL,
    [UsuarioElimino]   VARCHAR (250) NULL,
    [UsuarioActivo]    VARCHAR (250) NULL,
    [FechaActivacion]  DATETIME      NULL,
    [FechaRegistro]    DATETIME      NULL,
    [FechaEliminado]   DATETIME      NULL,
    [Flag]             BIT           NULL,
    [FlagBorrador]     BIT           NULL,
    CONSTRAINT [PK_Operacion] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Operacion__IdAni__415B2FED] FOREIGN KEY ([IdAnio]) REFERENCES [Maestro].[Anio] ([ID]),
    CONSTRAINT [FK__Operacion__IdEmp__47A76F72] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK_Operacion_PlanCuenta] FOREIGN KEY ([IdPlanCuenta]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK_Operacion_TipoMovimiento] FOREIGN KEY ([IdTipoMovimiento]) REFERENCES [Maestro].[TipoMovimiento] ([ID])
);
