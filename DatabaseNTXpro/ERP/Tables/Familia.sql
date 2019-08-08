CREATE TABLE [ERP].[Familia] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]         VARCHAR (MAX) NULL,
    [IdFamiliaPadre] INT           NULL,
    [IdEmpresa]      INT           NULL,
    [FlagSistema]    BIT           NULL,
    CONSTRAINT [PK__Familia__3214EC27979567B1] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Familia__IdEmpre__12404E51] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Familia__IdFamil__0C8774FB] FOREIGN KEY ([IdFamiliaPadre]) REFERENCES [ERP].[Familia] ([ID])
);

