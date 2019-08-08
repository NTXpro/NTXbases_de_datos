CREATE TABLE [Maestro].[TipoSueldo] (
    [ID]     INT             IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (100)   NULL,
    [Hora]   DECIMAL (18, 2) NULL,
    [Codigo] VARCHAR (10)    NULL,
    CONSTRAINT [PK_TipoSueldo] PRIMARY KEY CLUSTERED ([ID] ASC)
);

