CREATE TABLE [ERP].[AjusteCuentaCobrar] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [IdTipoComprobante] INT             NOT NULL,
    [IdCuentaCobrar]    INT             NOT NULL,
    [IdEntidad]         INT             NOT NULL,
    [IdMoneda]          INT             NULL,
    [IdEmpresa]         INT             NULL,
    [Fecha]             DATETIME        NULL,
    [Documento]         VARCHAR (20)    NULL,
    [Total]             DECIMAL (14, 5) NULL,
    [TipoCambio]        DECIMAL (14, 5) NULL,
    [UsuarioRegistro]   VARCHAR (250)   NULL,
    [FechaRegistro]     DATETIME        NULL,
    CONSTRAINT [PK__AjusteCu__3214EC27D80D864B] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__AjusteCue__IdCue__06EF628D] FOREIGN KEY ([IdCuentaCobrar]) REFERENCES [ERP].[CuentaCobrar] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdEmp__08D7AAFF] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdEnt__1631A61D] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdMon__07E386C6] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdTip__05071A1B] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

