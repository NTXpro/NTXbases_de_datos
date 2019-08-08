CREATE TABLE [PLAME].[T33RegimenLaboral] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]            VARCHAR (250) NULL,
    [NombreAbreviado]   VARCHAR (250) NULL,
    [CodigoSunat]       VARCHAR (5)   NULL,
    [FlagSectorPrivado] BIT           NULL,
    [FlagSectorPublico] BIT           NULL,
    [FlagOtraEntidad]   BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

