CREATE TABLE [ERP].[LetraPagar] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [IdProveedor]      INT             NULL,
    [IdEmpresa]        INT             NULL,
    [FechaEmision]     DATETIME        NULL,
    [FechaVencimiento] DATETIME        NULL,
    [Numero]           VARCHAR (20)    NULL,
    [DiasVencimiento]  INT             NULL,
    [Porcentaje]       DECIMAL (14, 5) NULL,
    [Monto]            DECIMAL (14, 5) NULL,
    [UsuarioRegistro]  VARCHAR (250)   NULL,
    [UsuarioModifico]  VARCHAR (250)   NULL,
    [FechaRegistro]    DATETIME        NULL,
    [FechaModificado]  DATETIME        NULL,
    [Serie]            VARCHAR (4)     NULL,
    [IdMoneda]         INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID]),
    CONSTRAINT [FK__LetraPaga__IdPro__1AB66418] FOREIGN KEY ([IdProveedor]) REFERENCES [ERP].[Proveedor] ([ID])
);

