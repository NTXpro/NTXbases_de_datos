CREATE TABLE [PLAME].[T1TipoActividad] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]       VARCHAR (50) NULL,
    [CodigoSunat]  CHAR (5)     NULL,
    [flagSunat]    BIT          NULL,
    [flagBorrador] BIT          NULL,
    [flag]         BIT          NULL,
    CONSTRAINT [PK_T1TipoActividad] PRIMARY KEY CLUSTERED ([ID] ASC)
);

