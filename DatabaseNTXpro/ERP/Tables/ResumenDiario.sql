CREATE TABLE [ERP].[ResumenDiario] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]              VARCHAR (250) NULL,
    [Fecha]               DATETIME      NULL,
    [Correlativo]         INT           NULL,
    [IdEmpresa]           INT           NULL,
    [TicketResumenDiario] VARCHAR (250) NULL,
    [FechaEnvio]          DATETIME      NULL,
    CONSTRAINT [PK__ResumenD__3214EC2777F56D54] PRIMARY KEY CLUSTERED ([ID] ASC)
);

