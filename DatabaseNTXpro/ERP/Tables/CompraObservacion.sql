CREATE TABLE [ERP].[CompraObservacion] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdCompra]        INT           NULL,
    [Observacion]     VARCHAR (255) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    CONSTRAINT [PK_CompraObservacion] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_CompraObservacion_Compra] FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID])
);

