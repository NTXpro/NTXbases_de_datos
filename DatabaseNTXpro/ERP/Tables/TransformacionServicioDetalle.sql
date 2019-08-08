CREATE TABLE [ERP].[TransformacionServicioDetalle] (
    [ID]                       BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdTransformacion]         INT             NULL,
    [IdTransformacionServicio] INT             NULL,
    [Cantidad]                 DECIMAL (18, 5) NULL,
    [PrecioUnitario]           DECIMAL (18, 5) NULL,
    [Total]                    DECIMAL (18, 5) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdTransformacionServicio]) REFERENCES [Maestro].[TransformacionServicio] ([ID]),
    CONSTRAINT [FK__Transform__IdTra__149D980F] FOREIGN KEY ([IdTransformacion]) REFERENCES [ERP].[Transformacion] ([ID])
);

