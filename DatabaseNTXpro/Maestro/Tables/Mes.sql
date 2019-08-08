CREATE TABLE [Maestro].[Mes] (
    [ID]               INT          IDENTITY (1, 1) NOT NULL,
    [Nombre]           VARCHAR (50) NULL,
    [Valor]            INT          NULL,
    [FlagContabilidad] BIT          NULL,
    CONSTRAINT [PK__Mes__0D1357C01540B47E] PRIMARY KEY CLUSTERED ([ID] ASC)
);

