

CREATE PROCEDURE [ERP].[Usp_Upd_Comparador]
@IdComparador	 INT,
@XMLComparador	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLComparador.nodes('/Comparador') AS T(N));
		DECLARE @Serie VARCHAR(4) = (SELECT T.N.value('Serie[1]','VARCHAR(4)') FROM @XMLComparador.nodes('/Comparador') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.Comparador WHERE ID = @IdComparador)
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLComparador.nodes('/Comparador') AS T(N)) = 0 ) 
		BEGIN
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST([Numero] AS INT)) FROM ERP.Comparador WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie AND FlagBorrador = 0);
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
			SET @Documento =  (SELECT Numero FROM ERP.Comparador WHERE ID = @IdComparador)
		END

		UPDATE ERP.Comparador
		SET IdMoneda = T.N.value('IdMoneda[1]',				'INT'),
			IdEstablecimiento = T.N.value('IdEstablecimiento[1]',				'INT'),
			IdAlmacen = T.N.value('IdAlmacen[1]',				'INT'),
			TipoCambio = T.N.value('TipoCambio[1]',				'DECIMAL(14,5)'),
			FECHA = T.N.value('Fecha[1]',				'DATETIME'),
			Numero = @Documento,
			Nombre = T.N.value('Nombre[1]',			'VARCHAR(250)'),
			Descripcion = T.N.value('Descripcion[1]',			'VARCHAR(250)'),
			UsuarioModifico = T.N.value('UsuarioModifico[1]',			'VARCHAR(20)'),
			FechaModificado = @FechaActual,
			FlagBorrador = T.N.value('FlagBorrador[1]',			'BIT')
		FROM @XMLComparador.nodes('/Comparador')	AS T(N)
		WHERE ID = @IdComparador

		DELETE FROM [ERP].ComparadorDetalle WHERE IdComparador = @IdComparador

		INSERT INTO [ERP].[ComparadorDetalle]
		 (
			 IdComparador
			,IdProducto
			,IdProveedor
			,Cantidad
			,Precio
			,Total
			,Seleccionado
		 )
		SELECT
		@IdComparador												AS IdComparador,
		T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
		CASE WHEN (T.N.value('IdProveedor[1]','INT') = 0) THEN
			NULL
		ELSE 
			T.N.value('IdProveedor[1]',			'INT')
		END					AS IdProveedor,
		T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
		T.N.value('Precio[1]'				,'DECIMAL(14,5)')		AS Precio,
		T.N.value('Total[1]'				,'DECIMAL(14,5)')		AS Total,
		T.N.value('Seleccionado[1]'			,'BIT')					AS Seleccionado
		FROM @XMLComparador.nodes('/ListaComparadorDetalle/ComparadorDetalle') AS T(N)	

		DELETE FROM [ERP].[ComparadorReferencia] WHERE IdComparador = @IdComparador

		INSERT INTO [ERP].[ComparadorReferencia]
		 (
			  IdComparador
			  ,IdReferenciaOrigen
			  ,IdReferencia
			  ,IdTipoComprobante
			  ,Serie
			  ,Documento
			  ,FlagInterno
		 )
		SELECT
		@IdComparador									AS IdRequerimiento,
		CASE WHEN (T.N.value('IdReferenciaOrigen[1]','INT') = 0) THEN
			NULL
		ELSE 
			T.N.value('IdReferenciaOrigen[1]',			'INT')
		END														AS IdReferenciaOrigen,
		T.N.value('IdReferencia[1]'	,'INT')					AS IdReferencia,
		T.N.value('IdTipoComprobante[1]'	,'INT')			AS IdTipoComprobante,
		T.N.value('Serie[1]'	,'VARCHAR(4)')				AS Serie,
		T.N.value('Documento[1]'	,'VARCHAR(8)')			AS Documento,
		T.N.value('FlagInterno[1]'	,'BIT')				AS FlagInterno
		FROM @XMLComparador.nodes('/ListaReferencia/Referencia') AS T(N)


		SET NOCOUNT OFF;
END