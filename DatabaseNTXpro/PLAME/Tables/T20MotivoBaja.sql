CREATE TABLE [PLAME].[T20MotivoBaja] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (250) NULL,
    [CodigoSunat] VARCHAR (50)  NULL,
    [Flag]        BIT           NULL,
    CONSTRAINT [PK__T20Motiv__3214EC27CC5C121A] PRIMARY KEY CLUSTERED ([ID] ASC)
);

