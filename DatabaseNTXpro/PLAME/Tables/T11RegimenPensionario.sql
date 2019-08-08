CREATE TABLE [PLAME].[T11RegimenPensionario] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (250) NULL,
    [CodigoSunat] VARCHAR (3)   NULL,
    [FlagONP]     BIT           NULL,
    [Abreviatura] VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

