CREATE PROCEDURE [ERP].[Usp_Upd_OrdenCompra]
@IdOrdenCompra	 INT,
@XMLOrdenCompra	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @Fecha DATETIME = (SELECT T.N.value('Fecha[1]','DATETIME') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N));
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N));
		DECLARE @Serie VARCHAR(4) = (SELECT T.N.value('Serie[1]','VARCHAR(4)') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.OrdenCompra WHERE ID = @IdOrdenCompra)
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N)) = 0) 
		BEGIN
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.OrdenCompra WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie AND FlagBorrador = 0);
			IF @UltimoCorrelativoGenerado IS NULL 
				BEGIN
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(1)), 8)
				END
			ELSE
				BEGIN
					SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8)
				END
		END

		IF @FlagBorrador = 0
		BEGIN
			SET @Documento =  (SELECT Documento FROM ERP.OrdenCompra WHERE ID = @IdOrdenCompra)
		END


		UPDATE ERP.OrdenCompra SET
			IdMoneda = T.N.value('IdMoneda[1]',	'INT'),
			IdProveedor = CASE WHEN (T.N.value('IdProveedor[1]','INT') = 0) THEN
							NULL
						ELSE 
							T.N.value('IdProveedor[1]',			'INT')
						END,
			IdProyecto = CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
							NULL
						ELSE 
							T.N.value('IdProyecto[1]',			'INT')
						END,
			IdEstablecimiento = CASE WHEN (T.N.value('IdEstablecimiento[1]','INT') = 0) THEN
							NULL
						ELSE 
							T.N.value('IdEstablecimiento[1]',			'INT')
						END,
			IdAlmacen = CASE WHEN (T.N.value('IdAlmacen[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdAlmacen[1]',			'INT')
			END,
			Fecha = T.N.value('Fecha[1]',				'DATETIME'),
			TipoCambio = T.N.value('TipoCambio[1]',	'DECIMAL(14,5)'),
			SubTotal = T.N.value('SubTotal[1]',	'DECIMAL(14,5)'),
			IGV = T.N.value('IGV[1]',	'DECIMAL(14,5)'),
			Total = T.N.value('Total[1]',	'DECIMAL(14,5)'),
			PorcentajeIGV = T.N.value('PorcentajeIGV[1]',	'DECIMAL(14,5)'),
			Serie = T.N.value('Serie[1]',			'VARCHAR(4)'),	
			Documento =  @Documento,
			DiasVencimiento = T.N.value('DiasVencimiento[1]',			'INT'),
			FechaVencimiento = T.N.value('FechaVencimiento[1]',		'DATETIME'),
			Observacion = T.N.value('Observacion[1]',	'VARCHAR(MAX)'),
			UsuarioModifico = T.N.value('UsuarioModifico[1]',		'VARCHAR(250)'),
			FechaModificado = DATEADD(HOUR, 3, GETDATE()),
			FlagBorrador = T.N.value('FlagBorrador[1]',		'BIT'),
		CondicionPago = T.N.value('CondicionPago[1]',		'VARCHAR(250)')
		FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra')	AS T(N)
		WHERE ID = @IdOrdenCompra
			
		DELETE FROM ERP.OrdenCompraDetalle WHERE IdOrdenCompra = @IdOrdenCompra

		INSERT INTO [ERP].[OrdenCompraDetalle]
		 (
		   IdOrdenCompra
		  ,IdProducto
		  ,Nombre
		  ,FlagAfecto
		  ,Cantidad
		  ,PrecioUnitario
		  ,SubTotal
		  ,IGV
		  ,Total	
		 )
		SELECT
		@IdOrdenCompra												AS IdOrdenCompra,
		T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
		T.N.value('Nombre[1]'					,'VARCHAR(255)')	AS Nombre,
		T.N.value('FlagAfecto[1]'				,'BIT')				AS FlagAfecto,
		T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
		T.N.value('PrecioUnitario[1]'			,'DECIMAL(14,5)')	AS PrecioUnitario,
		T.N.value('SubTotal[1]'			,'DECIMAL(14,5)')			AS SubTotal,
		T.N.value('IGV[1]'				,'DECIMAL(14,5)')			AS IGV,
		T.N.value('Total[1]'				,'DECIMAL(14,5)')		AS Total
		FROM @XMLOrdenCompra.nodes('/ListaArchivoPlanoOrdenCompraDetalle/ArchivoPlanoOrdenCompraDetalle') AS T(N)	

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N)) = 0)
		BEGIN
			UPDATE R SET
					R.IdRequerimientoEstado = 3
			FROM ERP.Requerimiento R
			INNER JOIN ERP.OrdenCompraReferencia CR ON CR.IdReferencia = R.ID
			WHERE CR.IdReferenciaOrigen = 6 AND CR.IdOrdenCompra = @IdOrdenCompra 
		END

		DELETE FROM ERP.OrdenCompraReferencia WHERE IdOrdenCompra = @IdOrdenCompra

		INSERT INTO ERP.OrdenCompraReferencia(
										  IdOrdenCompra,
										  IdReferenciaOrigen,
										  IdReferencia,
										  IdTipoComprobante,
										  Serie,
										  Documento,
										  FlagInterno
										)
		SELECT 
				@IdOrdenCompra,
				CASE WHEN (T.N.value('IdReferenciaOrigen[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdReferenciaOrigen[1]',			'INT')
				END														AS IdReferenciaOrigen,
				CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
				T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
				T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
				T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
				T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
				FROM @XMLOrdenCompra.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N)) = 0)
		BEGIN
			UPDATE R SET
					R.IdRequerimientoEstado = T.N.value('IdEstado[1]','INT') --IMPORTADO
			FROM ERP.Requerimiento R
			INNER JOIN @XMLOrdenCompra.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N) ON T.N.value('IdReferencia[1]','INT') = R.ID
			WHERE T.N.value('IdReferenciaOrigen[1]'	,'INT') = 6 
		END

		SET NOCOUNT OFF;

		-- JACH
		-- Hay totales que no se actualizan
		-- con este proceso nos aseguramos que si esta en cero se actualicen los totales
		Update ERP.ordencompra
		SET SubTotal=OCD.SubTotal, IGV=OCD.IGV, Total=OCD.Total 
		From ERP.ordencompra OC 
		Inner Join 
		(
		Select OC.id, SUM(OCD.SubTotal) SubTotal, SUM(OCD.IGV) IGV, SUM(OCD.Total) Total
		From ERP.ordencompra OC 
		Inner Join ERP.ordencompradetalle OCD
		on OC.ID=OCD.idOrdenCompra 
		where OC.Subtotal=0 and OC.flag=1 and OC.flagborrador=0
		Group by OC.id, OC.SubTotal, OC.IGV, OC.Total
		)
		OCD
		on OC.ID=OCD.ID

END