CREATE TABLE [PLAME].[T22IngresoTributoDescuento] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]      VARCHAR (500) NULL,
    [CodigoSunat] VARCHAR (10)  NULL,
    CONSTRAINT [PK_T22IngresoTributoDescuento] PRIMARY KEY CLUSTERED ([ID] ASC)
);

