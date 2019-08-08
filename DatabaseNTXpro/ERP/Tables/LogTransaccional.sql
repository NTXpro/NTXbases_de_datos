CREATE TABLE [ERP].[LogTransaccional] (
    [ID]          INT             IDENTITY (1, 1) NOT NULL,
    [tipo]        INT             NULL,
    [Modulo]      VARCHAR (50)    NULL,
    [Proceso]     VARCHAR (250)   NULL,
    [Descripcion] NVARCHAR (1024) NULL,
    [usuario]     VARCHAR (50)    NULL,
    [fecha]       DATETIME        NULL,
    CONSTRAINT [PK_LogTransaccional] PRIMARY KEY CLUSTERED ([ID] ASC)
);

