CREATE TABLE [Maestro].[OrdenCompraEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] VARCHAR (4)  NULL,
    CONSTRAINT [PK_OrdenCompraEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

