CREATE TABLE [ERP].[ImportacionServicioDetalle] (
    [ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [IdImportacion]         INT             NULL,
    [IdImportacionServicio] INT             NULL,
    [TipoCambio]            DECIMAL (18, 5) NULL,
    [Soles]                 DECIMAL (18, 5) NULL,
    [Dolares]               DECIMAL (18, 5) NULL,
    FOREIGN KEY ([IdImportacion]) REFERENCES [ERP].[Importacion] ([ID]),
    FOREIGN KEY ([IdImportacionServicio]) REFERENCES [Maestro].[ImportacionServicio] ([ID])
);

