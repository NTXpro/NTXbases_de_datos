
CREATE PROCEDURE [ERP].[Usp_Upd_ValeTransferencia]
@IdValeTransferencia	 INT,
@DataResult VARCHAR(MAX) OUT,
@XMLValeTransferencia	 XML,
@XMLValeOrigen	 XML,
@XMLValeDestino	 XML
AS
BEGIN		
SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET @DataResult = '';
		DECLARE @IdValeOrigen INT = (SELECT IdValeOrigen FROM ERP.ValeTransferencia WHERE ID = @IdValeTransferencia);
		DECLARE @IdValeDestino INT = (SELECT IdValeDestino FROM ERP.ValeTransferencia WHERE ID = @IdValeTransferencia);
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @Fecha DATETIME = (SELECT T.N.value('Fecha[1]','DATETIME') FROM @XMLValeTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N));
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLValeTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N));
		DECLARE @IdTipoMovimiento INT = (SELECT T.N.value('IdTipoMovimiento[1]','INT') FROM @XMLValeTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.ValeTransferencia WHERE ID = @IdValeTransferencia)
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLValeTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N)) = 0 ) 
		BEGIN
			------========= SE GENERAN EL CORRELATIVO DE LA TRANSFERENCIA =========------
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.ValeTransferencia WHERE IdEmpresa = @IdEmpresa AND FlagBorrador = 0);
			IF @UltimoCorrelativoGenerado IS NULL 
				BEGIN
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(1)), 8)
				END
			ELSE
				BEGIN
					SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8)
				END
			----===============================================================-------
			------========= SE GENERAN LOS VALES DE INGRESO Y SALIDA =========------

			IF @IdValeOrigen IS NULL --VALE DE SALIDA
			BEGIN
				EXEC [ERP].[Usp_Ins_Vale] @IdValeOrigen OUT,@DataResult OUT, @XMLValeOrigen
			END
			ELSE
			BEGIN
				EXEC [ERP].[Usp_Upd_Vale] @IdValeOrigen,@DataResult OUT, @XMLValeOrigen
			END

			IF @IdValeDestino IS NULL AND LEN(@DataResult) = 0 --VALE DE INGRESO
			BEGIN
				EXEC [ERP].[Usp_Ins_Vale] @IdValeDestino OUT,@DataResult OUT, @XMLValeDestino
			END
			ELSE IF LEN(@DataResult) = 0
			BEGIN
				EXEC [ERP].[Usp_Upd_Vale] @IdValeDestino,@DataResult OUT, @XMLValeDestino
			END
			----===============================================================-------
		END
		
		IF @FlagBorrador = 0
			BEGIN
				SET @Documento =  (SELECT Documento FROM ERP.ValeTransferencia WHERE ID = @IdValeTransferencia)
			END

		IF(LEN(@DataResult) = 0)
		BEGIN
			------========= SE MODIFICA LA TRANSFERENCIA CABECERA =========------
			UPDATE ERP.ValeTransferencia SET
				IdAlmacenOrigen=	CASE WHEN (T.N.value('IdAlmacenOrigen[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdAlmacenOrigen[1]',			'INT')
									END,
				IdAlmacenDestino=	CASE WHEN (T.N.value('IdAlmacenDestino[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdAlmacenDestino[1]',			'INT')
									END,
				IdMoneda		= 	CASE WHEN (T.N.value('IdMoneda[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdMoneda[1]',			'INT')
									END,
				Documento		=   @Documento,
				IdValeOrigen	=	CASE WHEN (@IdValeOrigen = 0) THEN
										NULL
									ELSE 
										@IdValeOrigen
									END,
				IdValeDestino	=	CASE WHEN (@IdValeDestino = 0) THEN
										NULL
									ELSE 
										@IdValeDestino
									END,
				Fecha			=	T.N.value('Fecha[1]',					'DATETIME'),
				Observacion		=	T.N.value('Observacion[1]',				'VARCHAR(250)'),
				TipoCambio		=	T.N.value('TipoCambio[1]',				'DECIMAL(14,5)'),
				PorcentajeIGV	=	T.N.value('PorcentajeIGV[1]',				'DECIMAL(14,5)'),
				SubTotal		=	T.N.value('SubTotal[1]',				'DECIMAL(14,5)'),
				IGV				=	T.N.value('IGV[1]',						'DECIMAL(14,5)'),
				Total			=	T.N.value('Total[1]',					'DECIMAL(14,5)'),
				UsuarioModifico =   T.N.value('UsuarioModifico[1]',			'VARCHAR(250)'),
				FechaModificado =   DATEADD(HOUR, 3, GETDATE()),
				FlagBorrador	=	T.N.value('FlagBorrador[1]',			'BIT')
			FROM @XMLValeTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N)
			WHERE ID = @IdValeTransferencia

			----===============================================================-------

			------========= SE INSERTA LA TRANSFERENCIA DETALLE =========------
			DELETE FROM [ERP].[ValeTransferenciaDetalle] WHERE IdValeTransferencia = @IdValeTransferencia

			INSERT INTO [ERP].[ValeTransferenciaDetalle]
				 (
					 IdValeTransferencia
					,IdProducto
					,Nombre
					,FlagAfecto
					,Cantidad			
					,PrecioUnitario
					,SubTotal
					,IGV
					,Total
					,Fecha
					,NumeroLote
				 )
				SELECT
				@IdValeTransferencia														AS IdVale,
				T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
				T.N.value('Nombre[1]'					,'VARCHAR(255)')	AS Nombre,
				T.N.value('FlagAfecto[1]'				,'BIT')				AS FlagAfecto,
				T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
				T.N.value('PrecioUnitario[1]'			,'DECIMAL(14,5)')	AS PrecioUnitario,
				T.N.value('SubTotal[1]'			,'DECIMAL(14,5)')			AS SubTotal,
				T.N.value('IGV[1]'				,'DECIMAL(14,5)')			AS IGV,
				T.N.value('Total[1]'				,'DECIMAL(14,5)')		AS Total,
				T.N.value('Fecha[1]'				,'DATETIME')			AS Fecha,
				T.N.value('NumeroLote[1]','VARCHAR(20)') NumeroLote
				FROM @XMLValeTransferencia.nodes('/ListaArchivoPlanoTransferenciaDetalle/ArchivoPlanoTransferenciaDetalle') AS T(N)	
			----===============================================================-------


			------========= SE INSERTA LA TRANSFERENCIA REFERENCIA =========------
			DELETE FROM [ERP].[ValeTransferenciaReferencia] WHERE IdValeTransferencia = @IdValeTransferencia
		
			INSERT INTO ERP.ValeTransferenciaReferencia(
												IdValeTransferencia,
												IdReferenciaOrigen,
												IdReferencia,
												IdTipoComprobante,
												Serie,
												Documento,
												FlagInterno
											)
			SELECT 
					@IdValeTransferencia,
					T.N.value('IdReferenciaOrigen[1]'	,'INT')				AS IdCompraReferencia,
					CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
					T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
					T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
					T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
					T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
					FROM @XMLValeTransferencia.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)
			----===============================================================-------

			SELECT @IdValeTransferencia

		END
		ELSE
		BEGIN
			SELECT -1
		END
	
END
