﻿CREATE TABLE [ERP].[GuiaRemision] (
    [ID]                        INT             IDENTITY (1, 1) NOT NULL,
    [IdTipoComprobante]         INT             NULL,
    [IdEntidad]                 INT             NULL,
    [IdEmpresa]                 INT             NULL,
    [IdGuiaRemisionEstado]      INT             NULL,
    [IdMoneda]                  INT             NULL,
    [IdEstablecimiento]         INT             NULL,
    [IdChofer]                  INT             NULL,
    [IdTransporte]              INT             NULL,
    [IdVehiculo]                INT             NULL,
    [IdAlmacen]                 INT             NULL,
    [IdMotivoTraslado]          INT             NULL,
    [IdVale]                    INT             NULL,
    [IdUnidadMedida]            INT             NULL,
    [IdModalidadTraslado]       INT             NULL,
    [IdUbigeoOrigen]            INT             NULL,
    [IdUbigeoDestino]           INT             NULL,
    [IdTipoMovimiento]          INT             NULL,
    [TipoCambio]                DECIMAL (14, 5) NULL,
    [Fecha]                     DATETIME        NULL,
    [Serie]                     VARCHAR (4)     NULL,
    [Documento]                 VARCHAR (8)     NULL,
    [Observacion]               VARCHAR (250)   NULL,
    [NumeroContenedor]          VARCHAR (50)    NULL,
    [CodigoPuerto]              VARCHAR (50)    NULL,
    [CorrelativoAnulacionSunat] INT             NULL,
    [TicketAnulacion]           VARCHAR (250)   NULL,
    [UsuarioAnulo]              VARCHAR (250)   NULL,
    [FechaAnulado]              DATETIME        NULL,
    [EstablecimientoOrigen]     VARCHAR (250)   NULL,
    [EstablecimientoDestino]    VARCHAR (250)   NULL,
    [PorcentajeIGV]             DECIMAL (14, 5) NULL,
    [SubTotal]                  DECIMAL (14, 5) NULL,
    [IGV]                       DECIMAL (14, 5) NULL,
    [Total]                     DECIMAL (14, 5) NULL,
    [TotalPeso]                 DECIMAL (14, 5) NULL,
    [Flag]                      BIT             NULL,
    [FlagBorrador]              BIT             NULL,
    [FlagGuiaElectronico]       BIT             NULL,
    [FlagValidarStock]          BIT             NULL,
    [UsuarioRegistro]           VARCHAR (250)   NULL,
    [UsuarioModifico]           VARCHAR (250)   NULL,
    [FechaRegistro]             DATETIME        NULL,
    [FechaModificado]           DATETIME        NULL,
    [RutaDocumentoXML]          VARCHAR (MAX)   NULL,
    [RutaDocumentoCDR]          VARCHAR (MAX)   NULL,
    [RutaDocumentoPDF]          VARCHAR (MAX)   NULL,
    [CodigoHash]                VARCHAR (MAX)   NULL,
    [SignatureValue]            VARCHAR (MAX)   NULL,
    [IdListaPrecio]             INT             NULL,
    [IdVendedor]                INT             NULL,
    CONSTRAINT [PK__GuiaRemi__3214EC276447B2C9] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([IdListaPrecio]) REFERENCES [ERP].[ListaPrecio] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdEnt__3CCB84FA] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdGui__0E109611] FOREIGN KEY ([IdGuiaRemisionEstado]) REFERENCES [Maestro].[GuiaRemisionEstado] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdMod__63E5521B] FOREIGN KEY ([IdModalidadTraslado]) REFERENCES [XML].[T18ModalidadTraslado] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdMot__6014C137] FOREIGN KEY ([IdMotivoTraslado]) REFERENCES [XML].[T20MotivoTraslado] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdTip__5AE5F7C6] FOREIGN KEY ([IdTipoMovimiento]) REFERENCES [Maestro].[TipoMovimiento] ([ID]),
    CONSTRAINT [FK__GuiaRemis__IdUni__6108E570] FOREIGN KEY ([IdUnidadMedida]) REFERENCES [PLE].[T6UnidadMedida] ([ID])
);
