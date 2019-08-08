﻿CREATE TABLE [ERP].[Concepto] (
    [ID]                        INT             IDENTITY (1, 1) NOT NULL,
    [IdEmpresa]                 INT             NULL,
    [IdTipoConcepto]            INT             NULL,
    [IdClase]                   INT             NULL,
    [IdIngresoTributoDescuento] INT             NULL,
    [Orden]                     INT             NULL,
    [Nombre]                    VARCHAR (250)   NULL,
    [Abreviatura]               VARCHAR (50)    NULL,
    [PorDefecto]                DECIMAL (18, 2) NULL,
    [FlagSiemprePlanilla]       BIT             NULL,
    [FlagEstructuraPlanilla]    BIT             NULL,
    [UsuarioRegistro]           VARCHAR (250)   NULL,
    [FechaRegistro]             DATETIME        NULL,
    [UsuarioModifico]           VARCHAR (250)   NULL,
    [FechaModificado]           DATETIME        NULL,
    [UsuarioElimino]            VARCHAR (250)   NULL,
    [FechaEliminado]            DATETIME        NULL,
    [UsuarioActivo]             VARCHAR (250)   NULL,
    [FechaActivacion]           DATETIME        NULL,
    [FlagBorrador]              BIT             NULL,
    [Flag]                      BIT             NULL,
    CONSTRAINT [PK_Concepto] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Concepto__IdClas__357F68ED] FOREIGN KEY ([IdClase]) REFERENCES [Maestro].[Clase] ([ID]),
    CONSTRAINT [FK__Concepto__IdEmpr__32A2FC42] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Concepto__IdIngr__36738D26] FOREIGN KEY ([IdIngresoTributoDescuento]) REFERENCES [PLAME].[T22IngresoTributoDescuento] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__43CD8844] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__44C1AC7D] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__45B5D0B6] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__46A9F4EF] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__479E1928] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__48923D61] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4986619A] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4A7A85D3] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4B6EAA0C] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4C62CE45] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4D56F27E] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4E4B16B7] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__4F3F3AF0] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__50335F29] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__51278362] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__521BA79B] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__530FCBD4] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__5403F00D] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__54F81446] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__55EC387F] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__56E05CB8] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__57D480F1] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__58C8A52A] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__59BCC963] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__5AB0ED9C] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__5BA511D5] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__5C99360E] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID]),
    CONSTRAINT [FK__Concepto__IdTipo__5D8D5A47] FOREIGN KEY ([IdTipoConcepto]) REFERENCES [Maestro].[TipoConcepto] ([ID])
);

