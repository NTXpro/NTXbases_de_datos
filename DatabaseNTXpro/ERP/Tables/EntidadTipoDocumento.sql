CREATE TABLE [ERP].[EntidadTipoDocumento] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [IdEntidad]       INT          NOT NULL,
    [IdTipoDocumento] INT          NOT NULL,
    [NumeroDocumento] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__EntidadTi__IdEnt__69FBBC1F] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__EntidadTi__IdTip__0F183235] FOREIGN KEY ([IdTipoDocumento]) REFERENCES [PLE].[T2TipoDocumento] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_NumeroDocumento]
    ON [ERP].[EntidadTipoDocumento]([IdTipoDocumento] ASC, [NumeroDocumento] ASC);

