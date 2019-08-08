CREATE TABLE [ERP].[TrabajadorPension] (
    [ID]                   INT          IDENTITY (1, 1) NOT NULL,
    [IdTrabajador]         INT          NULL,
    [IdRegimenPensionario] INT          NULL,
    [IdEmpresa]            INT          NULL,
    [FechaInicio]          DATETIME     NULL,
    [FechaFin]             DATETIME     NULL,
    [Cuspp]                VARCHAR (20) NULL,
    [IdTipoComision]       INT          NULL,
    CONSTRAINT [PK__Pension__3214EC27A7759F3A] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdTipoComision]) REFERENCES [Maestro].[TipoComision] ([ID]),
    CONSTRAINT [FK__Pension__IdEmpre__5A11CF1E] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Pension__IdRegim__5270AD56] FOREIGN KEY ([IdRegimenPensionario]) REFERENCES [PLAME].[T11RegimenPensionario] ([ID]),
    CONSTRAINT [FK__Pension__IdTraba__5364D18F] FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID])
);

