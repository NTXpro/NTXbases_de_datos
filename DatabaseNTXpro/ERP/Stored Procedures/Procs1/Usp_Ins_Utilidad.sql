
CREATE PROCEDURE [ERP].[Usp_Ins_Utilidad]
@IdUtilidad	 INT OUTPUT,
@XMLUtilidad	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		INSERT INTO ERP.Utilidad(
								   IdEmpresa
								  ,IdAnioProcesado
								  ,IdPeriodoTrabajado
								  ,RentaAnual
								  ,PorcentajeDistribuir
								  ,UtilidadDistribuir
								  ,IdTipoPago
								  ,PorcentajeDiaTrabajado
								  ,PorcentajeRemuneracionPercibida
								  ,TotalDiasTrabajados
								  ,TotalRemuneracionPercibida
								  ,TotalUtilidadDiasTrabajados
								  ,TotalUtilidadRemuneracionPercibida
								  ,TotalUtilidad
								  ,UsuarioRegistro
								  ,FechaRegistro
									) 
		SELECT
			T.N.value('IdEmpresa[1]',			'INT')		AS IdEmpresa,
			T.N.value('IdAnioProcesado[1]',	'INT')			AS IdAnioProcesado,
			T.N.value('IdPeriodoTrabajado[1]',	'INT')		AS IdPeriodoTrabajado,
			T.N.value('RentaAnual[1]',	'DECIMAL(14,5)')	AS RentaAnual,
			T.N.value('PorcentajeDistribuir[1]','DECIMAL(14,5)')	AS PorcentajeDistribuir,
			T.N.value('UtilidadDistribuir[1]','DECIMAL(14,5)')	AS UtilidadDistribuir,
			T.N.value('IdTipoPago[1]','INT')	AS IdTipoPago,
			T.N.value('PorcentajeDiaTrabajado[1]','DECIMAL(14,5)')	AS PorcentajeDiaTrabajado,
			T.N.value('PorcentajeRemuneracionPercibida[1]','DECIMAL(14,5)')	AS PorcentajeRemuneracionPercibida,
			T.N.value('TotalDiasTrabajados[1]','DECIMAL(14,5)')	AS TotalDiasTrabajados,
			T.N.value('TotalRemuneracionPercibida[1]','DECIMAL(14,5)')	AS TotalRemuneracionPercibida,
			T.N.value('TotalUtilidadDiasTrabajados[1]','DECIMAL(14,5)')	AS TotalUtilidadDiasTrabajados,
			T.N.value('TotalUtilidadRemuneracionPercibida[1]','DECIMAL(14,5)')	AS TotalUtilidadRemuneracionPercibida,
			T.N.value('TotalUtilidad[1]','DECIMAL(14,5)')	AS TotalUtilidad,
			T.N.value('UsuarioRegistro[1]','VARCHAR(250)')	AS UsuarioRegistro,
			@FechaActual FechaRegistro
		FROM @XMLUtilidad.nodes('/ArchivoPlanoUtilidad')	AS T(N)
		SET @IdUtilidad = SCOPE_IDENTITY();


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
