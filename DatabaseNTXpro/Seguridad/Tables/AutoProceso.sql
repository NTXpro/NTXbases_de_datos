CREATE TABLE [Seguridad].[AutoProceso] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Proceso]        NVARCHAR (50) NULL,
    [FechaEjecucion] DATETIME      NULL,
    [Flag]           INT           NULL,
    [Observaciones]  VARCHAR (500) NULL,
    CONSTRAINT [PK_AutoProceso] PRIMARY KEY CLUSTERED ([ID] ASC)
);

