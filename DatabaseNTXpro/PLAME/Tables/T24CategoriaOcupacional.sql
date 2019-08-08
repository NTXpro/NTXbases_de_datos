CREATE TABLE [PLAME].[T24CategoriaOcupacional] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (250) NULL,
    [CodigoSunat]     VARCHAR (50)  NULL,
    [FlagPrivado]     BIT           NULL,
    [FlagPublico]     BIT           NULL,
    [FlagOtraEntidad] BIT           NULL,
    CONSTRAINT [PK__T24Categ__3214EC27BD42BACA] PRIMARY KEY CLUSTERED ([ID] ASC)
);

