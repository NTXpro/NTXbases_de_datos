CREATE TABLE [Maestro].[Puesto] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IdOcupacion]     INT           NULL,
    [Nombre]          VARCHAR (250) NULL,
    [FechaRegistro]   DATETIME      NULL,
    [FechaEliminado]  DATETIME      NULL,
    [FlagSunat]       BIT           NULL,
    [FlagBorrador]    BIT           NULL,
    [Flag]            BIT           NULL,
    [FechaModificado] DATETIME      NULL,
    [FechaActivacion] DATETIME      NULL,
    [UsuarioRegistro] VARCHAR (250) NULL,
    [UsuarioElimino]  VARCHAR (250) NULL,
    [UsuarioModifico] VARCHAR (250) NULL,
    [UsuarioActivo]   VARCHAR (250) NULL,
    CONSTRAINT [PK__Puesto__3214EC2747BF976A] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Puesto__IdOcupac__2E734402] FOREIGN KEY ([IdOcupacion]) REFERENCES [PLAME].[T10Ocupacion] ([ID])
);

