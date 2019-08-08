CREATE PROCEDURE [ERP].[Usp_Ins_Compra]
@IdCompra	 INT OUTPUT,
@XMLCompra	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]',	'INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
		DECLARE @IdDetraccion INT = (SELECT T.N.value('IdDetraccion[1]','INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))

		INSERT INTO ERP.Compra(
									 IdEmpresa
									,IdPeriodo
									,IdProveedor
									,FechaEmision
									,IdMoneda
									,IdTipoComprobante
									,Serie
									,Numero
									,TipoCambio
									,PorcentajeDetraccion
									,PorcentajeIGV
									,IdTipoIGV
									,DiasVencimiento
									,FechaVencimiento
									,FechaRecepcion
									,BaseImponible
									,Inafecto
									,IGV
									,ISC
									,OtroImpuesto
									,Descuento
									,RedondeoSuma
									,RedondeoResta
									,Total
									,FlagBorrador
									,IdDetraccion
									,Flag
									,FechaRegistro
									,UsuarioRegistro
									,Descripcion
									,ImpuestoRenta
									,FlagImpuestoSegundaCategoria
									,ImpuestoRentaSegundaCategoria
									) 
		SELECT
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			T.N.value('IdPeriodo[1]','INT')							AS IdPeriodo,						
			CASE WHEN (T.N.value('IdProveedor[1]','INT') = 0) THEN	NULL ELSE 	T.N.value('IdProveedor[1]',			'INT')	END	AS IdProveedor,																				
			T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,								
			T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,									
			T.N.value('IdTipoComprobante[1]',	'INT')				AS IdTipoComprobante,							
			T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,										
			T.N.value('Numero[1]',				'VARCHAR(20)')		AS Numero,										
			T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,			
			T.N.value('PorcentajeDetraccion[1]',					'DECIMAL(14,5)')	AS PorcentajeDetraccion,								
			T.N.value('IGV[1]',					'DECIMAL(14,5)')	AS PorcentajeIGV,		
			CASE WHEN (T.N.value('IdTipoIGV[1]','INT') = 0) THEN NULL ELSE T.N.value('IdTipoIGV[1]',			'INT') END	AS IdTipoIGV,
			T.N.value('DiasVencimiento[1]',		'INT')				AS DiasVencimiento,									
			T.N.value('FechaVencimiento[1]',	'DATETIME')			AS FechaVencimiento,	
			T.N.value('FechaRecepcion[1]',		'DATETIME')			AS FechaRecepcion,					
			T.N.value('BaseImponible[1]',		'DECIMAL(14,5)')	AS BaseImponible,								
			T.N.value('Inafecto[1]',			'DECIMAL(14,5)')	AS Inafecto,									
			T.N.value('PorcentajeIGV[1]',		'DECIMAL(14,5)')	AS IGV,											
			T.N.value('ISC[1]',					'DECIMAL(14,5)')	AS ISC,											
			T.N.value('OtroImpuesto[1]',		'DECIMAL(14,5)')	AS OtroImpuesto,								
			T.N.value('Descuento[1]',			'DECIMAL(14,5)')	AS Descuento,									
			T.N.value('RedondeoSuma[1]',		'DECIMAL(14,5)')	AS RedondeoSuma,								
			T.N.value('RedondeoResta[1]',		'DECIMAL(14,5)')	AS RedondeoResta,								
			T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Total,										
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			CASE WHEN (T.N.value('IdDetraccion[1]','INT') = 0) THEN NULL ELSE T.N.value('IdDetraccion[1]',			'INT')END	AS IdDetraccion,	
			CAST(1 AS BIT)											AS Flag,
			DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			T.N.value('Descripcion[1]',			'VARCHAR(MAX)')		AS Descripcion,
			T.N.value('ImpuestoRenta[1]',		'DECIMAL(14,5)')	AS ImpuestoRenta,
			T.N.value('FlagImpuestoSegundaCategoria[1]',				'BIT')				AS FlagImpuestoSegundaCategoria,
			T.N.value('ImpuestoRentaSegundaCategoria[1]',		'DECIMAL(14,5)')	AS ImpuestoRentaSegundaCategoria
			
		FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)
		SET @IdCompra = SCOPE_IDENTITY()

		INSERT INTO [ERP].[CompraDetalle](
				IdCompra,
				Orden,
				IdOperacion,
				IdPlanCuenta,
				IdProyecto,
				Nombre,
				Importe,
				FlagAfecto
		)
		SELECT
		@IdCompra													AS IdCompra,
		T.N.value('Orden[1]',				'INT')					AS Orden,								
		CASE WHEN (T.N.value('IdOperacion[1]','INT') = 0) THEN	NULL ELSE T.N.value('IdOperacion[1]',			'INT')	END	AS IdOperacion,																						
		CASE WHEN (T.N.value('IdPlanCuenta[1]','INT') = 0) THEN	NULL ELSE T.N.value('IdPlanCuenta[1]',			'INT') END	AS IdPlanCuenta,
		CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN NULL ELSE T.N.value('IdProyecto[1]',			'INT')	END	AS IdProyecto,																											
		T.N.value('Glosa[1]',				'VARCHAR(250)')		AS Nombre,										
		T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Importe,									
		T.N.value('Afecto[1]',				'BIT')				AS FlagAfecto								
		FROM @XMLCompra.nodes('/ListaArchivoPlanoCompraDetalle/ArchivoPlanoCompraDetalle')	AS T(N)


		DELETE ERP.CompraDetalle WHERE IdCompra = @IdCompra

		INSERT INTO ERP.CompraReferencia(
										  IdCompra,
										  IdReferenciaOrigen,
										  IdReferencia,
										  IdTipoComprobante,
										  Serie,
										  Documento,
										  FlagInterno
										)
										SELECT 
												@IdCompra,
												T.N.value('IdReferenciaOrigen[1]'	,'INT')				AS IdCompraReferencia,
												CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
												T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
												T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
												T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
												T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
												FROM @XMLCompra.nodes('/ListaArchivoPlanoCompraReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)

		SET NOCOUNT OFF;
END