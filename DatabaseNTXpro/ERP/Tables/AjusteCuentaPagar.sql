CREATE TABLE [ERP].[AjusteCuentaPagar] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [IdTipoComprobante] INT             NOT NULL,
    [IdCuentaPagar]     INT             NOT NULL,
    [IdEntidad]         INT             NOT NULL,
    [IdMoneda]          INT             NULL,
    [IdEmpresa]         INT             NULL,
    [Fecha]             DATETIME        NULL,
    [Documento]         VARCHAR (20)    NULL,
    [Total]             DECIMAL (14, 5) NULL,
    [TipoCambio]        DECIMAL (14, 5) NULL,
    [UsuarioRegistro]   VARCHAR (250)   NULL,
    [FechaRegistro]     DATETIME        NULL,
    CONSTRAINT [PK__AjusteCu__3214EC277ABDD2FC] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__AjusteCue__IdCue__0D9C601C] FOREIGN KEY ([IdCuentaPagar]) REFERENCES [ERP].[CuentaPagar] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdEmp__0F84A88E] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdEnt__1725CA56] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdMon__0E908455] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__AjusteCue__IdTip__0BB417AA] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID])
);

