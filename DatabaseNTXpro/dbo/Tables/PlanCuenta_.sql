CREATE TABLE [dbo].[PlanCuenta$] (
    [ID]                   NCHAR (50)     NULL,
    [IdEmpresa]            FLOAT (53)     NULL,
    [IdAnio]               FLOAT (53)     NULL,
    [CuentaContable]       NVARCHAR (255) NULL,
    [Nombre]               NVARCHAR (255) NULL,
    [IdGrado]              FLOAT (53)     NULL,
    [IdColumnaBalance]     FLOAT (53)     NULL,
    [IdMoneda]             FLOAT (53)     NULL,
    [IdTipoCambio]         FLOAT (53)     NULL,
    [EstadoAnalisis]       FLOAT (53)     NULL,
    [EstadoProyecto]       FLOAT (53)     NULL,
    [FlagBorrador]         FLOAT (53)     NULL,
    [Flag]                 FLOAT (53)     NULL,
    [CuentaDestino1]       NVARCHAR (255) NULL,
    [NombreCuentaDestino1] NVARCHAR (255) NULL,
    [CuentaDestino2]       NVARCHAR (255) NULL,
    [NombreCuentaDestino2] NVARCHAR (255) NULL
);

