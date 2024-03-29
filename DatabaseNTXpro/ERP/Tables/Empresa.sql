﻿CREATE TABLE [ERP].[Empresa] (
    [ID]                          INT             IDENTITY (1, 1) NOT NULL,
    [IdEntidad]                   INT             NULL,
    [IdTipoActividad]             INT             NULL,
    [FechaRegistro]               DATETIME        NULL,
    [FechaEliminado]              DATETIME        NULL,
    [FlagBorrador]                BIT             NULL,
    [Flag]                        BIT             NULL,
    [FlagPrincipal]               BIT             NULL,
    [FechaModificado]             DATETIME        NULL,
    [UsuarioRegistro]             VARCHAR (250)   NULL,
    [UsuarioModifico]             VARCHAR (250)   NULL,
    [UsuarioElimino]              VARCHAR (250)   NULL,
    [UsuarioActivo]               VARCHAR (250)   NULL,
    [FechaActivacion]             DATETIME        NULL,
    [Imagen]                      VARBINARY (MAX) NULL,
    [NombreImagen]                VARCHAR (250)   NULL,
    [NumeroResolucion]            VARCHAR (50)    NULL,
    [Celular]                     VARCHAR (50)    NULL,
    [Telefono]                    VARCHAR (50)    NULL,
    [Web]                         VARCHAR (250)   NULL,
    [Correo]                      VARCHAR (250)   NULL,
    [FlagPlantillaEmpresa]        BIT             NULL,
    [FirmaDigital]                VARCHAR (250)   NULL,
    [ContraseniaFirmaDigital]     VARCHAR (250)   NULL,
    [IdEntidadRepresentanteLegal] INT             NULL,
    CONSTRAINT [PK__Empresa__5EF4033E0A80E286] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Empresa__IdEntid__160F4887] FOREIGN KEY ([IdEntidad]) REFERENCES [ERP].[Entidad] ([ID]),
    CONSTRAINT [FK_Empresa_T1TipoActividad] FOREIGN KEY ([IdTipoActividad]) REFERENCES [PLAME].[T1TipoActividad] ([ID])
);

