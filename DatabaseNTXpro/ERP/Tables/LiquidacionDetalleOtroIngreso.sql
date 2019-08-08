CREATE TABLE [ERP].[LiquidacionDetalleOtroIngreso] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [IdLiquidacionDetalle] INT             NULL,
    [IdConcepto]           INT             NULL,
    [Total]                DECIMAL (14, 5) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    FOREIGN KEY ([IdLiquidacionDetalle]) REFERENCES [ERP].[LiquidacionDetalle] ([ID])
);

