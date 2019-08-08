CREATE TABLE [ERP].[AFP] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [IdEntidad] INT          NULL,
    [Codigo]    VARCHAR (10) NULL,
    [FlagTope]  BIT          NULL,
    [Flag]      BIT          NULL,
    CONSTRAINT [PK_AFP] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__AFP__IdEntidad__35D46EA8] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID])
);

