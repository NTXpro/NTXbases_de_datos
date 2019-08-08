CREATE TABLE [ERP].[CompraDetraccion] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [IdCompra]        INT             NULL,
    [IdDetraccion]    INT             NULL,
    [Comprobante]     CHAR (10)       NULL,
    [Porcentaje]      INT             NULL,
    [Importe]         DECIMAL (14, 5) NULL,
    [FechaModificado] DATETIME        NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [UsuarioElimino]  VARCHAR (250)   NULL,
    [UsuarioActivo]   VARCHAR (250)   NULL,
    [FechaActivacion] DATETIME        NULL,
    [FechaRegistro]   DATETIME        NULL,
    [FechaDetraccion] DATETIME        NULL,
    CONSTRAINT [PK_CompraDetraccion] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_CompraDetraccion_Compra] FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID]),
    CONSTRAINT [FK_CompraDetraccion_Detraccion] FOREIGN KEY ([IdDetraccion]) REFERENCES [Maestro].[Detraccion] ([ID])
);

