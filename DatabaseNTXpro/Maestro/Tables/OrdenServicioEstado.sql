CREATE TABLE [Maestro].[OrdenServicioEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] VARCHAR (4)  NULL,
    CONSTRAINT [PK_OrdenServicioEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

