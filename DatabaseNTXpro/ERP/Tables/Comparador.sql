CREATE TABLE [ERP].[Comparador] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [Fecha]             DATETIME        NULL,
    [Numero]            VARCHAR (20)    NULL,
    [Nombre]            VARCHAR (250)   NULL,
    [Descripcion]       VARCHAR (250)   NULL,
    [UsuarioRegistro]   VARCHAR (250)   NULL,
    [FechaRegistro]     DATETIME        NULL,
    [UsuarioModifico]   VARCHAR (250)   NULL,
    [FechaModificado]   DATETIME        NULL,
    [IdEmpresa]         INT             NULL,
    [FlagBorrador]      BIT             NULL,
    [Serie]             VARCHAR (4)     NULL,
    [Flag]              BIT             NULL,
    [FlagGeneroOC]      BIT             NULL,
    [IdEstablecimiento] INT             NULL,
    [IdAlmacen]         INT             NULL,
    [IdMoneda]          INT             NULL,
    [TipoCambio]        DECIMAL (14, 5) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

