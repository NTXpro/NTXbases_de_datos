CREATE TABLE [PLAME].[T7Ubigeo] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]       VARCHAR (50) NULL,
    [CodigoSunat]  CHAR (6)     NULL,
    [FlagSunat]    BIT          NULL,
    [FlagBorrador] BIT          NULL,
    [Flag]         BIT          NULL,
    CONSTRAINT [PK_T7Ubigeo] PRIMARY KEY CLUSTERED ([ID] ASC)
);

