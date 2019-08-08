
CREATE PROCEDURE [ERP].[Usp_Upd_LiquidacionDetalle]
@IdLiquidacionDetalle INT OUTPUT,
@XMLLiquidacion	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		UPDATE [ERP].[LiquidacionDetalle] SET
		  Sueldo = T.N.value('Sueldo[1]','DECIMAL(14,5)')
		  ,CTSTrunca = T.N.value('CTSTrunca[1]','DECIMAL(14,5)')
		  ,VacacionTrunca = T.N.value('VacacionTrunca[1]','DECIMAL(14,5)')
		  ,GratificacionTrunca = T.N.value('GratificacionTrunca[1]'	,'DECIMAL(14,5)')
		  ,OtroIngreso = T.N.value('OtroIngreso[1]'	,'DECIMAL(14,5)')
		  ,Descuento =T.N.value('Descuento[1]'	,'DECIMAL(14,5)')
		  ,OtroDescuento =T.N.value('OtroDescuento[1]','DECIMAL(14,5)')
		  ,Aportacion =T.N.value('Aportacion[1]','DECIMAL(14,5)')
		  ,TotalLiquidacion =T.N.value('TotalLiquidacion[1]','DECIMAL(14,5)')
		  ,FechaInicioGratificacion =T.N.value('FechaInicioGratificacion[1]','DATETIME')
		  ,FechaFinGratificacion = T.N.value('FechaFinGratificacion[1]','DATETIME')
		  ,AsignacionFamiliarGratificacion = T.N.value('AsignacionFamiliarGratificacion[1]','DECIMAL(14,5)')
		  ,BonificacionGratificacion = T.N.value('BonificacionGratificacion[1]','DECIMAL(14,5)')
		  ,ComisionGratificacion = T.N.value('ComisionGratificacion[1]','DECIMAL(14,5)')
		  ,HE25Gratificacion = T.N.value('HE25Gratificacion[1]','DECIMAL(14,5)')
		  ,HE35Gratificacion = T.N.value('HE35Gratificacion[1]','DECIMAL(14,5)')
		  ,HE100Gratificacion = T.N.value('HE100Gratificacion[1]','DECIMAL(14,5)')
		  ,MesGratificacion = T.N.value('MesGratificacion[1]','INT')
		  ,DiaGratificacion = T.N.value('DiaGratificacion[1]','INT')
		  ,FechaInicioVacacion = T.N.value('FechaInicioVacacion[1]','DATETIME')
		  ,FechaFinVacacion = T.N.value('FechaFinVacacion[1]','DATETIME')
		  ,AsignacionFamiliarVacacion = T.N.value('AsignacionFamiliarVacacion[1]','DECIMAL(14,5)')
		  ,BonificacionVacacion = T.N.value('BonificacionVacacion[1]','DECIMAL(14,5)')
		  ,ComisionVacacion = T.N.value('ComisionVacacion[1]','DECIMAL(14,5)')
		  ,HE25Vacacion = T.N.value('HE25Vacacion[1]','DECIMAL(14,5)')
		  ,HE35Vacacion = T.N.value('HE35Vacacion[1]','DECIMAL(14,5)')
		  ,HE100Vacacion = T.N.value('HE100Vacacion[1]','DECIMAL(14,5)')
		  ,FechaInicioCTS = T.N.value('FechaInicioCTS[1]','DATETIME')
		  ,FechaFinCTS = T.N.value('FechaFinCTS[1]','DATETIME')
		  ,AsignacionFamiliarCTS = T.N.value('AsignacionFamiliarCTS[1]','DECIMAL(14,5)')
		  ,BonificacionCTS = T.N.value('BonificacionCTS[1]','DECIMAL(14,5)')
		  ,ComisionCTS = T.N.value('ComisionCTS[1]','DECIMAL(14,5)')
		  ,HE25CTS = T.N.value('HE25CTS[1]','DECIMAL(14,5)')
		  ,HE35CTS = T.N.value('HE35CTS[1]','DECIMAL(14,5)')
		  ,HE100CTS = T.N.value('HE100CTS[1]','DECIMAL(14,5)')
		  ,MesCTS = T.N.value('MesCTS[1]','INT')
		  ,DiaCTS = T.N.value('DiaCTS[1]','INT')
		FROM @XMLLiquidacion.nodes('/ListaArchivoPlanoLiquidacionDetalle/ArchivoPlanoLiquidacionDetalle') AS T(N)	
		WHERE ID = @IdLiquidacionDetalle

		DELETE FROM ERP.LiquidacionDetalleOtroDescuento WHERE IdLiquidacionDetalle = @IdLiquidacionDetalle;

		INSERT INTO ERP.LiquidacionDetalleOtroDescuento
			(
				IdLiquidacionDetalle
				,IdConcepto
				,Total
			)
		SELECT
		@IdLiquidacionDetalle										AS IdLiquidacionDetalle,
		T.N.value('IdConcepto[1]'				,'INT')				AS IdConcepto,
		T.N.value('Total[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioIGV
		FROM @XMLLiquidacion.nodes('/ListaArchivoPlanoLiquidacionDetalleOtroDescuento/ArchivoPlanoLiquidacionDetalleOtro') AS T(N)	


		DELETE FROM ERP.LiquidacionDetalleOtroIngreso WHERE IdLiquidacionDetalle = @IdLiquidacionDetalle;

		INSERT INTO ERP.LiquidacionDetalleOtroIngreso
			(
				IdLiquidacionDetalle
				,IdConcepto
				,Total
			)
		SELECT
		@IdLiquidacionDetalle										AS IdLiquidacionDetalle,
		T.N.value('IdConcepto[1]'				,'INT')				AS IdConcepto,
		T.N.value('Total[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioIGV
		FROM @XMLLiquidacion.nodes('/ListaArchivoPlanoLiquidacionDetalleOtroIngreso/ArchivoPlanoLiquidacionDetalleOtro') AS T(N)	

		SET NOCOUNT OFF;
END
