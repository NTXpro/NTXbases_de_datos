CREATE TABLE [ERP].[TrabajadorFamilia] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [IdTrabajador]      INT           NULL,
    [IdEntidad]         INT           NULL,
    [IdVinculoFamiliar] INT           NULL,
    [FechaDeAlta]       DATETIME      NULL,
    [IdEstablecimiento] INT           NULL,
    [IdEmpresa]         INT           NULL,
    [FlagBaja]          BIT           NULL,
    [IdMotivoBaja]      INT           NULL,
    [FechaBaja]         DATETIME      NULL,
    [FechaRegistro]     DATETIME      NULL,
    [UsuarioRegistro]   VARCHAR (250) NULL,
    [FechaModificado]   DATETIME      NULL,
    [UsuarioModifico]   VARCHAR (250) NULL,
    [UsuarioBaja]       VARCHAR (250) NULL,
    CONSTRAINT [PK__Familiar__3214EC27C2D7347E] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Familiar__IdEnti__1B8A8CC0] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__Familiar__IdTrab__1A966887] FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID]),
    CONSTRAINT [FK__Familiar__IdVinc__3BF75C52] FOREIGN KEY ([IdVinculoFamiliar]) REFERENCES [PLAME].[T19VinculoFamiliar] ([ID])
);

