CREATE TABLE [Maestro].[CotizacionEstado] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (50) NULL,
    [Abreviatura] CHAR (1)     NULL,
    CONSTRAINT [PK_CotizacionEstado] PRIMARY KEY CLUSTERED ([ID] ASC)
);

