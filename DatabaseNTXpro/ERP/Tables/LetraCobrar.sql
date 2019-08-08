CREATE TABLE [ERP].[LetraCobrar] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [IdCliente]        INT             NULL,
    [IdEmpresa]        INT             NULL,
    [FechaEmision]     DATETIME        NULL,
    [FechaVencimiento] DATETIME        NULL,
    [Numero]           VARCHAR (8)     NULL,
    [DiasVencimiento]  INT             NULL,
    [Porcentaje]       DECIMAL (14, 5) NULL,
    [Monto]            DECIMAL (14, 5) NULL,
    [UsuarioRegistro]  VARCHAR (250)   NULL,
    [UsuarioModifico]  VARCHAR (250)   NULL,
    [FechaRegistro]    DATETIME        NULL,
    [FechaModificado]  DATETIME        NULL,
    [Serie]            VARCHAR (4)     NULL,
    [IdMoneda]         INT             NULL,
    CONSTRAINT [PK__LetraCob__3214EC273AD518E6] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__LetraCobr__IdCli__2EBD5CC5] FOREIGN KEY ([IdCliente]) REFERENCES [ERP].[Cliente] ([ID]),
    CONSTRAINT [FK__LetraCobr__IdEmp__2FB180FE] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID])
);

