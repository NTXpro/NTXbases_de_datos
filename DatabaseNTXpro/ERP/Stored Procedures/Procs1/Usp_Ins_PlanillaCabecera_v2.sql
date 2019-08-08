--- MIGRACION RRHH INFRASTRUCTURA

--agregar campo a la tabla datolaboraldetalle 
--[IdEstadoTrabajador] [int] NULL

--agregar campo a la tabla ReporteNomina 
--[CargoEmpleado] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,

--agregar campo a la tabla datolaboral
--[IdMotivoCese] [int]


-- Stored Procedure

-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 10/12/2018
-- Description:	INSERTA CABECERA PLANILLA AL MOMENTO DE GUARDAR LOS REGISTROS EN LA PLANILLA CALCULO
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Ins_PlanillaCabecera_v2]
  @FechaInicioNomina datetime,
  @FechaFinNomina datetime ,
  @idPlanilla	int,
  @idEmpresa int ,
  @IdTrabajador int
AS
BEGIN
DECLARE @Retorno int =0;
DECLARE  @idDld	int=0
DECLARE @NuevoIDCabecera int =0
DECLARE @HoraBase decimal(18,5) = 0
DECLARE @datolaboral int = 0;

------- insertar trabajadores a destiempo ---------
set @datolaboral =(SELECT top 1 dl.id  FROM ERP.DatoLaboral dl WHERE dl.IdTrabajador = @IdTrabajador AND dl.IdEmpresa = @idEmpresa
					AND DL.FechaInicio <= @FechaInicioNomina )
set @idDld = (SELECT dld.ID FROM ERP.DatoLaboralDetalle dld WHERE dld.IdDatoLaboral = @datolaboral AND dld.FechaInicio <= @FechaFinNomina AND (dld.FechaFin >= @FechaInicioNomina OR dld.FechaFin IS NULL))
	  -- IF NOT EXISTS (SELECT pc.ID FROM ERP.PlanillaCabecera pc WHERE pc.IdTrabajador = @IdTrabajador AND pc.IdDatoLaboralDetalle = @idDld AND pc.IdPlanilla=@idPlanilla AND pc.FechaIniPlanilla  = @FechaInicioNomina AND pc.FechaFinPlanilla = @FechaFinNomina)
	  --BEGIN
	  --   INSERT ERP.PlanillaCabecera
		 --( IdEmpresa,IdPeriodo,IdPlanilla,IdTrabajador,FechaInicio,FechaFin,Orden,CodigoProceso,TotalIngreso,TotalDescuentos,
			-- TotalAportes,NetoAPagar,IdDatoLaboralDetalle,FechaIniPlanilla,FechaFinPlanilla
		 --)
		 --VALUES
		 --(
			-- @idEmpresa, -- IdEmpresa - int
			-- (SELECT ERP.ObtenerIdPeriodo_By_Fecha(@FechaFinNomina)) , -- IdPeriodo - int
			-- @idPlanilla, -- IdPlanilla - int
			-- @IdTrabajador, -- IdTrabajador - int
			-- @FechaInicioNomina, -- FechaInicio - datetime
			-- @FechaFinNomina, -- FechaFin - datetime
			-- 0, -- Orden - int
			-- 'x', -- CodigoProceso - varchar
			-- 0, -- TotalIngreso - decimal
			-- 0, -- TotalDescuentos - decimal
			-- 0, -- TotalAportes - decimal
			-- 0, -- NetoAPagar - decimal
			-- @idDld, -- IdDatoLaboralDetalle - int
			-- @FechaInicioNomina, -- FechaIniPlanilla - datetime
			-- @FechaFinNomina -- FechaFinPlanilla - datetime
		 --)
		 --SELECT @NuevoIDCabecera = SCOPE_IDENTITY()
			--				INSERT ERP.PlanillaHojaTrabajo
			--				(
			--					--ID - column value is auto-generated
			--					IdPlanillaCabecera,
			--					IdConcepto,
			--					HoraPorcentaje
			--				)
			--				VALUES
			--				(
			--					-- ID - bigint
			--					@NuevoIDCabecera, -- IdPlanillaCabecera - bigint
			--					1, -- IdConcepto - int
			--					@HoraBase -- HoraPorcentaje - decimal
			--				)
		 ------ insertar valores de calculo
		 --SET @Retorno = @idDld

		 --end
		 --ELSE
		 --begin

				DECLARE db_cursor CURSOR FOR SELECT  dld.ID, dld.HoraBase  FROM ERP.DatoLaboralDetalle dld	 INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
											AND ((DL.FechaCese >= @FechaInicioNomina OR dl.FechaCese IS null) )
											INNER JOIN MAESTRO.Planilla p2 ON DLD.IdPlanilla = p2.ID 	 
											WHERE 
											dld.FechaInicio<= @FechaFinNomina 
											AND dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	 AND dl.IdTrabajador =@IdTrabajador						 
				OPEN db_cursor  
				FETCH NEXT FROM db_cursor INTO @idDld  ,@HoraBase

				WHILE @@FETCH_STATUS = 0  
				BEGIN 
					   IF NOT EXISTS (SELECT pc.ID FROM ERP.PlanillaCabecera pc WHERE pc.IdTrabajador = @IdTrabajador AND pc.IdDatoLaboralDetalle = @idDld AND pc.IdPlanilla=@idPlanilla AND pc.FechaIniPlanilla  = @FechaInicioNomina AND pc.FechaFinPlanilla = @FechaFinNomina)
					  BEGIN
						 INSERT ERP.PlanillaCabecera
						 ( IdEmpresa,IdPeriodo,IdPlanilla,IdTrabajador,FechaInicio,FechaFin,Orden,CodigoProceso,TotalIngreso,TotalDescuentos,
							 TotalAportes,NetoAPagar,IdDatoLaboralDetalle,FechaIniPlanilla,FechaFinPlanilla
						 )
						 VALUES
						 (
							 @idEmpresa, -- IdEmpresa - int
							 (SELECT ERP.ObtenerIdPeriodo_By_Fecha(@FechaFinNomina)) , -- IdPeriodo - int
							 @idPlanilla, -- IdPlanilla - int
							 @IdTrabajador, -- IdTrabajador - int
							 @FechaInicioNomina, -- FechaInicio - datetime
							 @FechaFinNomina, -- FechaFin - datetime
							 0, -- Orden - int
							 '', -- CodigoProceso - varchar
							 0, -- TotalIngreso - decimal
							 0, -- TotalDescuentos - decimal
							 0, -- TotalAportes - decimal
							 0, -- NetoAPagar - decimal
							 @idDld, -- IdDatoLaboralDetalle - int
							 @FechaInicioNomina, -- FechaIniPlanilla - datetime
							 @FechaFinNomina -- FechaFinPlanilla - datetime
						 )
						 SELECT @NuevoIDCabecera = SCOPE_IDENTITY()
							INSERT ERP.PlanillaHojaTrabajo
							(
								--ID - column value is auto-generated
								IdPlanillaCabecera,
								IdConcepto,
								HoraPorcentaje
							)
							VALUES
							(
								-- ID - bigint
								@NuevoIDCabecera, -- IdPlanillaCabecera - bigint
								1, -- IdConcepto - int
								@HoraBase -- HoraPorcentaje - decimal
							)

						 SET @Retorno = @idDld
					  END

					  FETCH NEXT FROM db_cursor INTO @idDld ,@HoraBase
				END 
				CLOSE db_cursor  
DEALLOCATE db_cursor 
SELECT @Retorno AS valor
--end

END