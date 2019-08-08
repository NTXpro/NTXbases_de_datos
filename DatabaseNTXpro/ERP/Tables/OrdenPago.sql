CREATE TABLE [ERP].[OrdenPago] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [IdProyecto]      INT             NULL,
    [IdEntidad]       INT             NULL,
    [IdMoneda]        INT             NULL,
    [IdEmpresa]       INT             NULL,
    [Fecha]           DATETIME        NULL,
    [Descripcion]     VARCHAR (MAX)   NULL,
    [TipoCambio]      DECIMAL (14, 5) NULL,
    [Total]           DECIMAL (14, 5) NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [FechaRegistro]   DATETIME        NULL,
    [FechaModificado] DATETIME        NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [Flag]            BIT             NULL,
    [FlagBorrador]    BIT             NULL,
    [Serie]           VARCHAR (4)     NULL,
    [Documento]       VARCHAR (8)     NULL,
    CONSTRAINT [PK__OrdenPag__3214EC2795D14992] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__OrdenPago__IdEnt__4B2F7E41] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__OrdenPago__IdMon__4C23A27A] FOREIGN KEY ([IdMoneda]) REFERENCES [Maestro].[Moneda] ([ID]),
    CONSTRAINT [FK__OrdenPago__IdPro__4A3B5A08] FOREIGN KEY ([IdProyecto]) REFERENCES [ERP].[Proyecto] ([ID])
);

