CREATE TABLE [PLE].[T10TipoComprobante] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]         VARCHAR (50)  NULL,
    [Descripcion]    VARCHAR (255) NULL,
    [CodigoSunat]    CHAR (2)      NULL,
    [Abreviatura]    CHAR (3)      NULL,
    [FechaRegistro]  DATETIME      NULL,
    [FechaEliminado] DATETIME      NULL,
    [FlagSunat]      BIT           NULL,
    [FlagBorrador]   BIT           NULL,
    [Flag]           BIT           NULL,
    CONSTRAINT [PK__T10TipoC__3214EC275498A60E] PRIMARY KEY CLUSTERED ([ID] ASC)
);

