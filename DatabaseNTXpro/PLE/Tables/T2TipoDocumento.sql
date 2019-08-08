CREATE TABLE [PLE].[T2TipoDocumento] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]       VARCHAR (50) NULL,
    [Abreviatura]  VARCHAR (20) NULL,
    [CodigoSunat]  CHAR (2)     NULL,
    [FlagSunat]    BIT          NULL,
    [FlagBorrador] BIT          NULL,
    [Flag]         BIT          NULL,
    CONSTRAINT [PK__T2TipoDo__3214EC27168F9EEB] PRIMARY KEY CLUSTERED ([ID] ASC)
);

