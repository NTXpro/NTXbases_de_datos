﻿CREATE TABLE [ERP].[GuiaRemisionDetalle] (
    [ID]                        INT             IDENTITY (1, 1) NOT NULL,
    [IdGuiaRemision]            INT             NULL,
    [IdProducto]                INT             NULL,
    [Nombre]                    VARCHAR (MAX)   NULL,
    [Cantidad]                  DECIMAL (14, 5) NULL,
    [Peso]                      DECIMAL (14, 5) NULL,
    [PesoUnitario]              DECIMAL (14, 5) NULL,
    [Lote]                      VARCHAR (250)   NULL,
    [PorcentajeISC]             DECIMAL (14, 5) NULL,
    [PrecioUnitarioLista]       DECIMAL (14, 5) NULL,
    [PrecioUnitarioListaSinIGV] DECIMAL (14, 5) NULL,
    [PrecioUnitarioValorISC]    DECIMAL (14, 5) NULL,
    [PrecioUnitarioISC]         DECIMAL (14, 5) NULL,
    [PrecioUnitarioSubTotal]    DECIMAL (14, 5) NULL,
    [PrecioUnitarioIGV]         DECIMAL (14, 5) NULL,
    [PrecioUnitarioTotal]       DECIMAL (14, 5) NULL,
    [PrecioLista]               DECIMAL (14, 5) NULL,
    [PrecioSubTotal]            DECIMAL (14, 5) NULL,
    [PrecioIGV]                 DECIMAL (14, 5) NULL,
    [PrecioTotal]               DECIMAL (14, 5) NULL,
    [FlagAfecto]                BIT             NULL,
    CONSTRAINT [PK__GuiaRemi__3214EC27F8CEDF9F] PRIMARY KEY CLUSTERED ([ID] ASC)
);

