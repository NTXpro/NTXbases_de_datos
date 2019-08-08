CREATE TABLE [Maestro].[TipoCuenta] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Nombre] VARCHAR (50) NULL,
    CONSTRAINT [PK_TipoCuenta] PRIMARY KEY CLUSTERED ([ID] ASC)
);

