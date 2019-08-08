CREATE TABLE [Maestro].[TipoEstadoTrabajador] (
    [Id]     INT           IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (100) NULL,
    CONSTRAINT [PK_TipoEstadoTrabajador] PRIMARY KEY CLUSTERED ([Id] ASC)
);

