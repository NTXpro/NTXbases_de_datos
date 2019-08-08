CREATE TABLE [ERP].[CTSDetalle] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IdCTS]              INT             NULL,
    [IdDatoLaboral]      INT             NULL,
    [Sueldo]             DECIMAL (14, 5) NULL,
    [AsignacionFamiliar] DECIMAL (14, 5) NULL,
    [Bonificacion]       DECIMAL (14, 5) NULL,
    [HE25]               DECIMAL (14, 5) NULL,
    [HE35]               DECIMAL (14, 5) NULL,
    [HE100]              DECIMAL (14, 5) NULL,
    [Comision]           DECIMAL (14, 5) NULL,
    [Remuneracion]       DECIMAL (14, 5) NULL,
    [Mes]                DECIMAL (14, 5) NULL,
    [ValorMes]           DECIMAL (14, 5) NULL,
    [ImporteMes]         DECIMAL (14, 5) NULL,
    [Dias]               DECIMAL (14, 5) NULL,
    [ValorDia]           DECIMAL (14, 5) NULL,
    [ImporteDia]         DECIMAL (14, 5) NULL,
    [TotalCTS]           DECIMAL (14, 5) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    CONSTRAINT [FK__CTSDetall__IdCTS__6A4836E7] FOREIGN KEY ([IdCTS]) REFERENCES [ERP].[CTS] ([ID])
);

