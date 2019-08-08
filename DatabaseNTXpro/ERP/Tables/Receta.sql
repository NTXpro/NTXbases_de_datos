CREATE TABLE [ERP].[Receta] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [idEmpresa]             INT           NULL,
    [Nombre]                VARCHAR (250) NULL,
    [ProductoTerminado]     VARCHAR (250) NULL,
    [CantidadProdTerminado] INT           NULL,
    [Fecha]                 DATETIME      NULL,
    [FechaIngreso]          DATETIME      NULL,
    [FechaSalida]           DATETIME      NULL,
    [UsuarioRegistro]       VARCHAR (250) NULL,
    [FechaRegistro]         DATETIME      NULL,
    [UsuarioModifico]       VARCHAR (250) NULL,
    [FechaModificado]       DATETIME      NULL,
    [UsuarioActivo]         VARCHAR (250) NULL,
    [FechaActivacion]       DATETIME      NULL,
    [UsuarioElimino]        VARCHAR (250) NULL,
    [FechaEliminado]        DATETIME      NULL,
    [FlagBorrador]          BIT           NULL,
    [Flag]                  BIT           NULL,
    [IdAlmacen]             INT           NULL,
    [IdProducto]            INT           NULL,
    CONSTRAINT [PK_ERP.Receta] PRIMARY KEY CLUSTERED ([ID] ASC)
);

