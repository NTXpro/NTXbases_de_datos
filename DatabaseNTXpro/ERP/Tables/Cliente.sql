﻿CREATE TABLE [ERP].[Cliente] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [IdEntidad]         INT           NULL,
    [IdEmpresa]         INT           NOT NULL,
    [IdVendedor]        INT           NULL,
    [IdTipoRelacion]    INT           NULL,
    [FechaRegistro]     DATETIME      NULL,
    [FechaEliminado]    DATETIME      NULL,
    [FlagBorrador]      BIT           NULL,
    [Flag]              BIT           NULL,
    [FechaModificado]   DATETIME      NULL,
    [UsuarioRegistro]   VARCHAR (250) NULL,
    [UsuarioModifico]   VARCHAR (250) NULL,
    [UsuarioElimino]    VARCHAR (250) NULL,
    [UsuarioActivo]     VARCHAR (250) NULL,
    [FechaActivacion]   DATETIME      NULL,
    [Correo]            VARCHAR (250) NULL,
    [DiasVencimiento]   INT           NULL,
    [FlagClienteBoleta] BIT           NULL,
    [AgenteRetencion]   BIT           NULL,
    CONSTRAINT [PK__Cliente__3214EC2700CC47AF] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Cliente__IdEmpre__062DE679] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__Cliente__IdEntid__0539C240] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK_Cliente_TipoRelacion] FOREIGN KEY ([IdTipoRelacion]) REFERENCES [Maestro].[TipoRelacion] ([ID]),
    CONSTRAINT [FK_Cliente_Vendedor] FOREIGN KEY ([IdVendedor]) REFERENCES [ERP].[Vendedor] ([ID])
);

