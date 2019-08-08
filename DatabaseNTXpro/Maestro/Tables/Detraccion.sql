CREATE TABLE [Maestro].[Detraccion] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (255)   NULL,
    [CodigoSunat]     VARCHAR (2)     NULL,
    [Anexo]           INT             NULL,
    [Orden]           INT             NULL,
    [Porcentaje]      DECIMAL (14, 5) NULL,
    [FechaRegistro]   DATETIME        NULL,
    [FechaActivacion] DATETIME        NULL,
    [FechaEliminado]  DATETIME        NULL,
    [FechaModificado] DATETIME        NULL,
    [UsuarioRegistro] VARCHAR (250)   NULL,
    [UsuarioModifico] VARCHAR (250)   NULL,
    [UsuarioActivo]   VARCHAR (250)   NULL,
    [UsuarioElimino]  VARCHAR (250)   NULL,
    [Flag]            BIT             NULL,
    [FlagBorrador]    BIT             NULL,
    CONSTRAINT [PK_Detraccion] PRIMARY KEY CLUSTERED ([ID] ASC)
);

