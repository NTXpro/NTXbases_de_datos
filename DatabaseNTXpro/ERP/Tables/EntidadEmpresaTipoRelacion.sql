CREATE TABLE [ERP].[EntidadEmpresaTipoRelacion] (
    [ID]             INT IDENTITY (1, 1) NOT NULL,
    [IdEntidad]      INT NOT NULL,
    [IdEmpresa]      INT NULL,
    [IdTipoRelacion] INT NOT NULL,
    CONSTRAINT [FK__EntidadTi__IdEmp__3E08F69F] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__EntidadTi__IdEnt__3D14D266] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__EntidadTi__IdTip__3EFD1AD8] FOREIGN KEY ([IdTipoRelacion]) REFERENCES [Maestro].[TipoRelacion] ([ID])
);

