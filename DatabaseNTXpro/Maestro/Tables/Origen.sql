CREATE TABLE [Maestro].[Origen] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]               VARCHAR (255) NULL,
    [Abreviatura]          VARCHAR (10)  NULL,
    [UsuarioRegistro]      VARCHAR (250) NULL,
    [FechaRegistro]        DATETIME      NULL,
    [UsuarioModifico]      VARCHAR (250) NULL,
    [FechaModificado]      DATETIME      NULL,
    [UsuarioElimino]       VARCHAR (250) NULL,
    [FechaEliminado]       DATETIME      NULL,
    [UsuarioActivo]        VARCHAR (250) NULL,
    [FechaActivacion]      DATETIME      NULL,
    [FlagOrigenAutomatico] BIT           NULL,
    [FlagSistema]          BIT           NULL,
    [FlagBorrador]         BIT           NULL,
    [Flag]                 BIT           NULL,
    [FlagEmpresa]          BIT           NULL,
    CONSTRAINT [PK__Origen__3214EC27AE34396E] PRIMARY KEY CLUSTERED ([ID] ASC)
);

