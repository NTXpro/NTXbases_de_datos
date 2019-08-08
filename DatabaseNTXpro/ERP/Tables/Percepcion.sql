CREATE TABLE [ERP].[Percepcion] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [IdCompra]          INT             NULL,
    [Fecha]             DATETIME        NULL,
    [IdTipoComprobante] INT             NULL,
    [IdTipoPercepcion]  INT             NULL,
    [Serie]             CHAR (4)        NULL,
    [Documento]         VARCHAR (20)    NULL,
    [Importe]           DECIMAL (14, 5) NULL,
    [FechaModificado]   DATETIME        NULL,
    [UsuarioRegistro]   VARCHAR (250)   NULL,
    [UsuarioModifico]   VARCHAR (250)   NULL,
    [UsuarioElimino]    VARCHAR (250)   NULL,
    [UsuarioActivo]     VARCHAR (250)   NULL,
    [FechaActivacion]   DATETIME        NULL,
    [Flag]              BIT             NULL,
    CONSTRAINT [PK_Percepcion] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Percepcion_Compra] FOREIGN KEY ([IdCompra]) REFERENCES [ERP].[Compra] ([ID]),
    CONSTRAINT [FK_Percepcion_T10TipoComprobante] FOREIGN KEY ([IdTipoComprobante]) REFERENCES [PLE].[T10TipoComprobante] ([ID]),
    CONSTRAINT [FK_Percepcion_TipoPercepcion] FOREIGN KEY ([IdTipoPercepcion]) REFERENCES [Maestro].[TipoPercepcion] ([ID])
);

