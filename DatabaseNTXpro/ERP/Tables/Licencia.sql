CREATE TABLE [ERP].[Licencia] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdCliente]       INT           NOT NULL,
    [IdVersion]       INT           NOT NULL,
    [FechaInicio]     DATETIME      NULL,
    [FechaFin]        DATETIME      NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [KF_Licencia_Version] FOREIGN KEY ([IdVersion]) REFERENCES [ERP].[Version] ([ID])
);

