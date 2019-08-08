CREATE TABLE [ERP].[EstructuraCuatro] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [IdEstructuraTres] INT           NULL,
    [CuentaContable]   VARCHAR (50)  NULL,
    [Operador]         INT           NULL,
    [Orden]            INT           NULL,
    [UsuarioRegistro]  VARCHAR (250) NULL,
    [FechaRegistro]    DATETIME      NULL,
    [UsuarioModifico]  VARCHAR (250) NULL,
    [FechaModificado]  DATETIME      NULL,
    [UsuarioActivo]    VARCHAR (250) NULL,
    [FechaActivacion]  DATETIME      NULL,
    [UsuarioElimino]   VARCHAR (250) NULL,
    [FechaEliminado]   DATETIME      NULL,
    [Flag]             BIT           NULL,
    CONSTRAINT [PK__Estructu__3214EC27B3F7587E] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Estructur__IdEst__393A1FE1] FOREIGN KEY ([IdEstructuraTres]) REFERENCES [ERP].[EstructuraTres] ([ID])
);

