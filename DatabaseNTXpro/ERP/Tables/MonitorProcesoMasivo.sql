CREATE TABLE [ERP].[MonitorProcesoMasivo] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Proceso]     NVARCHAR (50)  NULL,
    [Descripcion] NVARCHAR (500) NULL,
    CONSTRAINT [PK_ERP.MonitorProcesoMasivo] PRIMARY KEY CLUSTERED ([ID] ASC)
);

