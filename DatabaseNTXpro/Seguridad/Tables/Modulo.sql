CREATE TABLE [Seguridad].[Modulo] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [IdSistema] INT           NULL,
    [Nombre]    VARCHAR (20)  NULL,
    [Icono]     VARCHAR (100) NULL,
    [Orden]     INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Modulo__IdSistem__3429BB53] FOREIGN KEY ([IdSistema]) REFERENCES [Seguridad].[Sistema] ([ID])
);

