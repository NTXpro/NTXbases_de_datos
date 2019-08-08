
CREATE PROCEDURE [ERP].[Usp_Upd_Liquidacion_Reprocesar]
@IdLiquidacion	 INT,
@XMLLiquidacion	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		DECLARE @TablaDetalle AS TABLE(ID INT);

		INSERT INTO @TablaDetalle
		SELECT ID FROM [ERP].[LiquidacionDetalle] WHERE IdLiquidacion = @IdLiquidacion

		DELETE FROM [ERP].[LiquidacionDetalleOtroDescuento] WHERE IdLiquidacionDetalle IN (SELECT ID FROM @TablaDetalle);
		DELETE FROM [ERP].[LiquidacionDetalleOtroIngreso] WHERE IdLiquidacionDetalle IN (SELECT ID FROM @TablaDetalle);
		DELETE FROM [ERP].[LiquidacionDetalle] WHERE IdLiquidacion = @IdLiquidacion;

		INSERT INTO [ERP].[LiquidacionDetalle]
		 (
		   IdLiquidacion
		  ,IdDatoLaboral
		  ,Sueldo
		  ,CTSTrunca
		  ,VacacionTrunca
		  ,GratificacionTrunca
		  ,OtroIngreso
		  ,Descuento
		  ,OtroDescuento
		  ,Aportacion
		  ,TotalLiquidacion
		  ,FechaInicioGratificacion
		  ,FechaFinGratificacion
		  ,AsignacionFamiliarGratificacion
		  ,BonificacionGratificacion
		  ,ComisionGratificacion
		  ,HE25Gratificacion
		  ,HE35Gratificacion
		  ,HE100Gratificacion
		  ,MesGratificacion
		  ,DiaGratificacion
		  ,FechaInicioVacacion
		  ,FechaFinVacacion
		  ,AsignacionFamiliarVacacion
		  ,BonificacionVacacion
		  ,ComisionVacacion
		  ,HE25Vacacion
		  ,HE35Vacacion
		  ,HE100Vacacion
		  ,FechaInicioCTS
		  ,FechaFinCTS
		  ,AsignacionFamiliarCTS
		  ,BonificacionCTS
		  ,ComisionCTS
		  ,HE25CTS
		  ,HE35CTS
		  ,HE100CTS
		  ,MesCTS
		  ,DiaCTS
		 )
		SELECT
		@IdLiquidacion											AS IdLiquidacion,
		T.N.value('IdDatoLaboral[1]','INT')						AS IdDatoLaboral,
		T.N.value('Sueldo[1]','DECIMAL(14,5)')					AS Sueldo,
		T.N.value('CTSTrunca[1]','DECIMAL(14,5)')				AS CTSTrunca,
		T.N.value('VacacionTrunca[1]','DECIMAL(14,5)')			AS VacacionTrunca,
		T.N.value('GratificacionTrunca[1]'	,'DECIMAL(14,5)')	AS GratificacionTrunca,
		T.N.value('OtroIngreso[1]'	,'DECIMAL(14,5)')			AS OtroIngreso,
		T.N.value('Descuento[1]'	,'DECIMAL(14,5)')			AS Descuento,
		T.N.value('OtroDescuento[1]','DECIMAL(14,5)')			AS OtroDescuentro,
		T.N.value('Aportacion[1]','DECIMAL(14,5)')				AS Aportacion,
		T.N.value('TotalLiquidacion[1]','DECIMAL(14,5)')		AS TotalLiquidacion,
		T.N.value('FechaInicioGratificacion[1]','DATETIME')		AS FechaInicioGratificacion,
		T.N.value('FechaFinGratificacion[1]','DATETIME')		AS FechaFinGratificacion,
		T.N.value('AsignacionFamiliarGratificacion[1]','DECIMAL(14,5)')		AS AsignacionFamiliarGratificacion,
		T.N.value('BonificacionGratificacion[1]','DECIMAL(14,5)')		AS BonificacionGratificacion,
		T.N.value('ComisionGratificacion[1]','DECIMAL(14,5)')		AS ComisionGratificacion,
		T.N.value('HE25Gratificacion[1]','DECIMAL(14,5)')		AS HE25Gratificacion,
		T.N.value('HE35Gratificacion[1]','DECIMAL(14,5)')		AS HE35Gratificacion,
		T.N.value('HE100Gratificacion[1]','DECIMAL(14,5)')		AS HE100Gratificacion,
		T.N.value('MesGratificacion[1]','INT')					AS MesGratificacion,
		T.N.value('DiaGratificacion[1]','INT')					AS DiaGratificacion,
		T.N.value('FechaInicioVacacion[1]','DATETIME')			AS FechaInicioVacacion,
		T.N.value('FechaFinVacacion[1]','DATETIME')				AS FechaFinVacacion,
		T.N.value('AsignacionFamiliarVacacion[1]','DECIMAL(14,5)')		AS AsignacionFamiliarVacacion,
		T.N.value('BonificacionVacacion[1]','DECIMAL(14,5)')		AS BonificacionVacacion,
		T.N.value('ComisionVacacion[1]','DECIMAL(14,5)')		AS ComisionVacacion,
		T.N.value('HE25Vacacion[1]','DECIMAL(14,5)')		AS HE25Vacacion,
		T.N.value('HE35Vacacion[1]','DECIMAL(14,5)')		AS HE35Vacacion,
		T.N.value('HE100Vacacion[1]','DECIMAL(14,5)')		AS HE100Vacacion,  
		T.N.value('FechaInicioCTS[1]','DATETIME')			AS FechaInicioCTS,
		T.N.value('FechaFinCTS[1]','DATETIME')				AS FechaFinCTS,  
		T.N.value('AsignacionFamiliarCTS[1]','DECIMAL(14,5)')		AS AsignacionFamiliarCTS,
		T.N.value('BonificacionCTS[1]','DECIMAL(14,5)')		AS BonificacionCTS,
		T.N.value('ComisionCTS[1]','DECIMAL(14,5)')		AS ComisionCTS,
		T.N.value('HE25CTS[1]','DECIMAL(14,5)')		AS HE25CTS,
		T.N.value('HE35CTS[1]','DECIMAL(14,5)')		AS HE35CTS,
		T.N.value('HE100CTS[1]','DECIMAL(14,5)')	AS HE100CTS,
		T.N.value('MesCTS[1]','INT')					AS MesCTS,
		T.N.value('DiaCTS[1]','INT')					AS DiaCTS
		FROM @XMLLiquidacion.nodes('/ListaArchivoPlanoLiquidacionDetalle/ArchivoPlanoLiquidacionDetalle') AS T(N)	

		SET NOCOUNT OFF;
END
