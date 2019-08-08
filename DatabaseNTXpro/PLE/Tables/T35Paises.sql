CREATE TABLE [PLE].[T35Paises] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (250) NULL,
    [CodigoSunat] CHAR (4)      NULL,
    [FlagSunat]   BIT           NULL,
    CONSTRAINT [PK__T35Paise__3214EC274FE46908] PRIMARY KEY CLUSTERED ([ID] ASC)
);

