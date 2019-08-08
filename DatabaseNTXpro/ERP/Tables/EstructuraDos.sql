CREATE TABLE [ERP].[EstructuraDos] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdEstructuraUno] INT           NULL,
    [Nombre]          VARCHAR (200) NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [Flag]            BIT           NULL,
    CONSTRAINT [PK_EstructuraBalanceGeneralDos] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Estructur__IdEst__3381468B] FOREIGN KEY ([IdEstructuraUno]) REFERENCES [ERP].[EstructuraUno] ([ID])
);

