CREATE TABLE [ERP].[TipoCambioDiario] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [Fecha]           DATETIME        NULL,
    [VentaSunat]      DECIMAL (14, 5) NULL,
    [CompraSunat]     DECIMAL (14, 5) NULL,
    [VentaSBS]        DECIMAL (14, 5) NULL,
    [CompraSBS]       DECIMAL (14, 5) NULL,
    [VentaComercial]  DECIMAL (14, 5) NULL,
    [CompraComercial] DECIMAL (14, 5) NULL,
    [FechaModificado] DATETIME        NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [FechaRegistro]   DATETIME        NULL,
    CONSTRAINT [PK_TipoCambioDiario] PRIMARY KEY CLUSTERED ([ID] ASC)
);

