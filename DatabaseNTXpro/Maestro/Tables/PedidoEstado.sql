CREATE TABLE [Maestro].[PedidoEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] CHAR (2)     NULL,
    CONSTRAINT [PK_PedidoEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

