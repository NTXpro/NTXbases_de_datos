CREATE TABLE [PLAME].[T2TipoEstablecimiento] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]       VARCHAR (50) NULL,
    [CodigoSunat]  CHAR (2)     NULL,
    [FlagSunat]    BIT          NULL,
    [FlagBorrador] BIT          NULL,
    [Flag]         BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

