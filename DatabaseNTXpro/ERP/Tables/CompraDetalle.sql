CREATE TABLE [ERP].[CompraDetalle] (
    [ID]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdCompra]        INT             NULL,
    [Orden]           INT             NULL,
    [IdOperacion]     INT             NULL,
    [IdPlanCuenta]    INT             NULL,
    [IdProyecto]      INT             NULL,
    [Nombre]          VARCHAR (250)   NULL,
    [Importe]         DECIMAL (14, 5) NULL,
    [FlagAfecto]      BIT             NULL,
    [FechaModificado] DATETIME        NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [UsuarioElimino]  VARCHAR (250)   NULL,
    [UsuarioActivo]   VARCHAR (250)   NULL,
    [FechaActivacion] DATETIME        NULL,
    CONSTRAINT [PK_CompraDetalle] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_CompraDetalle_Compra] FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID]),
    CONSTRAINT [FK_CompraDetalle_Operacion] FOREIGN KEY ([IdOperacion]) REFERENCES [ERP].[Operacion] ([ID]),
    CONSTRAINT [FK_CompraDetalle_PlanCuenta] FOREIGN KEY ([IdPlanCuenta]) REFERENCES [ERP].[PlanCuenta] ([ID]),
    CONSTRAINT [FK_CompraDetalle_Proyecto] FOREIGN KEY ([IdProyecto]) REFERENCES [ERP].[Proyecto] ([ID])
);

