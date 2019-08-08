-- =============================================
-- Author:        Omar Rodriguez
-- Create date: 05/10/2018
-- Description:   Inserta registros de nuevo trabajador en las tablas de mantenimiento de RRHH
--                valores hardcoded, debe llamarse desde crear trabajador del menu inicial
--				  crear trabajador en el menu RRHH
-- =============================================
CREATE PROCEDURE [ERP].[spu_DatoLaboralyDatoLaboralDetalle_Insert_NuevoTrabajador]
	
		@IdEmpresa [int],
		@IdTrabajador [int],
		@FechaInicio [datetime],
		@UsuarioRegistro [varchar](250),
		@FechaRegistro [datetime]
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	BEGIN 
	DECLARE @IdDato  as int = 0
	INSERT INTO ERP.DatoLaboral
	(
		IdEmpresa, IdTrabajador, FechaInicio,ERP.DatoLaboral.FlagAsignacionFamiliar, UsuarioRegistro, FechaRegistro
	)
	VALUES
	(
		@IdEmpresa,
		@IdTrabajador,
		@FechaInicio,
		0,
		@UsuarioRegistro,
		@FechaRegistro
	)
	select @IdDato= SCOPE_IDENTITY()

	INSERT INTO ERP.DatoLaboralDetalle
(
    --ID 
    IdDatoLaboral,
    IdRegimenLaboral,
    IdTipoTrabajador,
    IdPuesto,
    IdTipoSueldo,
    Sueldo,
    FechaInicio,
    FechaFin,
    IdCategoriaDatoLaboral,
    IdPlanilla,
    IdCategoriaOcupacional,
    FlagJornadaTrabajoMaxima,
    FlagJornadaAtipica,
    FlagJornadaTrabajoHorarioNocturno,
    IdSituacionEspecialTrabajador,
    FlagSindicalizado,
    IdSituacionTrabajador,
    FlagPersonaDiscapacidad,
    UsuarioRegistro,
    FechaRegistro,
	HoraBase
)
VALUES
(
    -- ID - int
    @IdDato, -- IdDatoLaboral - int
    1, -- IdRegimenLaboral - int
    1, -- IdTipoTrabajador - int
    1, -- IdPuesto - int
    1, -- IdTipoSueldo - int
    0, -- Sueldo - decimal
    @FechaInicio, -- FechaInicio - datetime
    null, -- FechaFin - datetime
    1, -- IdCategoriaDatoLaboral - int
    1, -- IdPlanilla - int
    1, -- IdCategoriaOcupacional - int
    0, -- FlagJornadaTrabajoMaxima - bit
    0, -- FlagJornadaAtipica - bit
    0, -- FlagJornadaTrabajoHorarioNocturno - bit
    1, -- IdSituacionEspecialTrabajador - int
    0, -- FlagSindicalizado - bit
    2, -- IdSituacionTrabajador - int
    0, -- FlagPersonaDiscapacidad - bit
    @UsuarioRegistro, -- UsuarioRegistro - varchar
    @FechaRegistro, -- FechaRegistro - datetime   
	1  -- HoraBase
);
 
	END