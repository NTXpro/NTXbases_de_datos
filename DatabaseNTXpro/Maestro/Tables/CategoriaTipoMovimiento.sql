CREATE TABLE [Maestro].[CategoriaTipoMovimiento] (
    [ID]                                INT           IDENTITY (1, 1) NOT NULL,
    [IdTipoMovimiento]                  INT           NULL,
    [Nombre]                            VARCHAR (250) NULL,
    [Abreviatura]                       VARCHAR (50)  NULL,
    [FlagCheque]                        BIT           NULL,
    [FlagTransferencia]                 BIT           NULL,
    [IdCategoriaTipoMovimientoRelacion] INT           NULL,
    [Codigo]                            CHAR (2)      NULL,
    [IdSunat]                           VARCHAR (3)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdTipoMovimiento]) REFERENCES [Maestro].[TipoMovimiento] ([ID])
);

