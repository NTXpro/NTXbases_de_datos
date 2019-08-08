
CREATE PROCEDURE [ERP].[Usp_Upd_Utilidad]
@IdUtilidad	 INT,
@XMLUtilidad	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		UPDATE ERP.Utilidad SET
			IdPeriodoTrabajado = T.N.value('IdPeriodoTrabajado[1]',	'INT'),
			RentaAnual = T.N.value('RentaAnual[1]',	'DECIMAL(14,5)'),
			PorcentajeDistribuir = T.N.value('PorcentajeDistribuir[1]','DECIMAL(14,5)'),
			UtilidadDistribuir = T.N.value('UtilidadDistribuir[1]','DECIMAL(14,5)'),
			IdTipoPago = T.N.value('IdTipoPago[1]','INT'),
			PorcentajeDiaTrabajado = T.N.value('PorcentajeDiaTrabajado[1]','DECIMAL(14,5)'),
			PorcentajeRemuneracionPercibida = T.N.value('PorcentajeRemuneracionPercibida[1]','DECIMAL(14,5)'),
			TotalDiasTrabajados = T.N.value('TotalDiasTrabajados[1]','DECIMAL(14,5)'),
			TotalRemuneracionPercibida = T.N.value('TotalRemuneracionPercibida[1]','DECIMAL(14,5)'),
			TotalUtilidadDiasTrabajados = T.N.value('TotalUtilidadDiasTrabajados[1]','DECIMAL(14,5)'),
			TotalUtilidadRemuneracionPercibida = T.N.value('TotalUtilidadRemuneracionPercibida[1]','DECIMAL(14,5)'),
			TotalUtilidad = T.N.value('TotalUtilidad[1]','DECIMAL(14,5)')
		FROM @XMLUtilidad.nodes('/ArchivoPlanoUtilidad')	AS T(N)
		WHERE ID = @IdUtilidad

		DELETE FROM [ERP].[UtilidadDetalle] WHERE IdUtilidad = @IdUtilidad
		
		INSERT INTO [ERP].[UtilidadDetalle]
		 (
		   IdUtilidad
		  ,IdTrabajador
		  ,DiasTrabajados
		  ,RemuneracionPercibida
		  ,UtilidadDiasTrabajados
		  ,UtilidadRemuneracionPercibida
		  ,Utilidad
		 )
		SELECT
		@IdUtilidad										AS IdUtilidad,
		T.N.value('IdTrabajador[1]','INT')				AS IdTrabajador,
		T.N.value('DiasTrabajados[1]','DECIMAL(14,5)')	AS DiasTrabajados,
		T.N.value('RemuneracionPercibida[1]','DECIMAL(14,5)')	AS RemuneracionPercibida,
		T.N.value('UtilidadDiasTrabajados[1]','DECIMAL(14,5)')	AS UtilidadDiasTrabajados,
		T.N.value('UtilidadRemuneracionPercibida[1]','DECIMAL(14,5)')	AS UtilidadRemuneracionPercibida,
		T.N.value('Utilidad[1]','DECIMAL(14,5)')	AS Utilidad	
		FROM @XMLUtilidad.nodes('/ListaArchivoPlanoUtilidadDetalle/ArchivoPlanoUtilidadDetalle') AS T(N)	

		SET NOCOUNT OFF;
END
