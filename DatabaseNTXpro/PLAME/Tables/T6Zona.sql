CREATE TABLE [PLAME].[T6Zona] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]       VARCHAR (50) NULL,
    [CodigoSunat]  CHAR (2)     NULL,
    [FlagSunat]    BIT          NULL,
    [FlagBorrador] BIT          NULL,
    [Flag]         BIT          NULL,
    [Abreviatura]  VARCHAR (5)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

