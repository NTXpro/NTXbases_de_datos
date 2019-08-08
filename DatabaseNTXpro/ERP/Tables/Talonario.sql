CREATE TABLE [ERP].[Talonario] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [IdCuenta]        INT             NULL,
    [Fecha]           DATETIME        NULL,
    [Inicio]          INT             NULL,
    [Fin]             INT             NULL,
    [Total]           DECIMAL (16, 5) NULL,
    [Girado]          NCHAR (10)      NULL,
    [Anulado]         NCHAR (10)      NULL,
    [Ultimo]          NCHAR (10)      NULL,
    [IdEmpresa]       INT             NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [UsuarioElimino]  VARCHAR (250)   NULL,
    [UsuarioActivo]   VARCHAR (250)   NULL,
    [FechaRegistro]   DATETIME        NULL,
    [FechaModificado] DATETIME        NULL,
    [FechaEliminado]  DATETIME        NULL,
    [FechaActivacion] DATETIME        NULL,
    [Flag]            BIT             NULL,
    [FlagBorrador]    BIT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

