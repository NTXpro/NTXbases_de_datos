CREATE TABLE [ERP].[DatoLaboralAdelanto] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [IdDatoLaboral] INT           NULL,
    [IdEmpresa]     INT           NULL,
    [Motivo]        VARCHAR (250) NULL,
    [Fecha]         DATETIME      NULL,
    [Monto]         DECIMAL (18)  NULL,
    [FlagCancelado] BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID])
);

