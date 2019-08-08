CREATE TABLE [Maestro].[Planilla] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (250) NULL,
    [Codigo]          VARCHAR (20)  NULL,
    [IdTipoPlanilla]  INT           NULL,
    [IdEmpresa]       INT           NULL,
    [Dia]             INT           NULL,
    [FlagDiaMes]      BIT           NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [FechaModificado] DATETIME      NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [FechaEliminado]  DATETIME      NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    [FechaActivacion] DATETIME      NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    CONSTRAINT [PK__Planilla__3214EC275DFF08FB] PRIMARY KEY CLUSTERED ([ID] ASC)
);

