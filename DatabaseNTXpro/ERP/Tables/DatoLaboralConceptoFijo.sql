CREATE TABLE [ERP].[DatoLaboralConceptoFijo] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IdDatoLaboral]      INT             NULL,
    [IdConcepto]         INT             NULL,
    [IdTipoConceptoFijo] INT             NULL,
    [IdEmpresa]          INT             NULL,
    [IdPeriodoInicio]    INT             NULL,
    [IdPeriodoFin]       INT             NULL,
    [Monto]              DECIMAL (14, 5) NULL,
    CONSTRAINT [PK__Concepto__3214EC27C58BD19B] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__ConceptoF__IdDat__69891CD8] FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    CONSTRAINT [FK__ConceptoF__IdEmp__6B71654A] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__ConceptoF__IdPer__19382FFA] FOREIGN KEY ([IdPeriodoInicio]) REFERENCES [ERP].[Periodo] ([ID]),
    CONSTRAINT [FK__ConceptoF__IdPer__1A2C5433] FOREIGN KEY ([IdPeriodoFin]) REFERENCES [ERP].[Periodo] ([ID]),
    CONSTRAINT [FK__ConceptoF__IdTip__6A7D4111] FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    CONSTRAINT [FK__ConceptoF__IdTip__6E4DD1F5] FOREIGN KEY ([IdTipoConceptoFijo]) REFERENCES [Maestro].[TipoConceptoFijo] ([ID])
);

