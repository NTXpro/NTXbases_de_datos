CREATE TABLE [PLAME].[T8TipoTrabajador] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]          VARCHAR (250) NULL,
    [Descripcion]     VARCHAR (250) NULL,
    [CodigoSunat]     VARCHAR (3)   NULL,
    [FlagPrivado]     BIT           NULL,
    [FlagPublico]     BIT           NULL,
    [FlagOtraEntidad] BIT           NULL,
    CONSTRAINT [PK__T8TipoTr__3214EC278CE3E687] PRIMARY KEY CLUSTERED ([ID] ASC)
);

