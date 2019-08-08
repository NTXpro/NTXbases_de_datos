
CREATE PROCEDURE [ERP].[Usp_Upd_Compra]
@IdCompra	 INT ,
@XMLCompra	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000

		DECLARE @IdDetraccion INT = (SELECT T.N.value('IdDetraccion[1]','INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
		DECLARE @FlagBorrador BIT = (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
		DECLARE @IdPeriodo INT = (SELECT T.N.value('IdPeriodo[1]','INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
		DECLARE @Orden INT = (SELECT T.N.value('Orden[1]','INT')FROM @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N))
		DECLARE @OrdenCompra INT = (SELECT CAST(Orden AS INT) FROM ERP.Compra WHERE ID = @IdCompra)

		IF @FlagBorrador = 0
			BEGIN
				IF @OrdenCompra IS NULL
					BEGIN 
							SET @OrdenCompra = (SELECT (ERP.GenerarOrdenCompra(@IdPeriodo,@IdEmpresa)))
							UPDATE ERP.Compra SET Orden = @OrdenCompra WHERE ID = @IdCompra
					END
			END
		
		UPDATE ERP.Compra 
		SET		IdProveedor = CASE WHEN (T.N.value('IdProveedor[1]','INT') = 0) THEN	NULL ELSE T.N.value('IdProveedor[1]',	'INT')	END,
				FechaEmision = T.N.value('FechaEmision[1]',	'DATETIME')	,
				IdMoneda = T.N.value('IdMoneda[1]',			'INT'),
				IdTipoComprobante = T.N.value('IdTipoComprobante[1]',	'INT'),
				Serie = T.N.value('Serie[1]',				'CHAR(4)'),
				IdPeriodo = T.N.value('IdPeriodo[1]',	'INT'),
				Numero= T.N.value('Numero[1]',				'VARCHAR(20)'),
				PorcentajeIGV = T.N.value('IGV[1]',			'DECIMAL(14,5)'),
				IdTipoIGV = CASE WHEN (T.N.value('IdTipoIGV[1]','INT') = 0) THEN NULL ELSE T.N.value('IdTipoIGV[1]', 'INT') END,
				DiasVencimiento = T.N.value('DiasVencimiento[1]',	'INT')	,
				FechaRecepcion= T.N.value('FechaRecepcion[1]',	'DATETIME')	,
				FechaVencimiento= T.N.value('FechaVencimiento[1]',	'DATETIME')	,
				TipoCambio = T.N.value('TipoCambio[1]',	'DECIMAL(14,5)')	,
				BaseImponible = T.N.value('BaseImponible[1]',		'DECIMAL(14,5)'),
				Inafecto = T.N.value('Inafecto[1]',			'DECIMAL(14,5)'),
				IGV = T.N.value('PorcentajeIGV[1]',			'DECIMAL(14,5)'),
				PorcentajeDetraccion = T.N.value('PorcentajeDetraccion[1]',			'DECIMAL(14,5)'),
				ISC = T.N.value('ISC[1]',					'DECIMAL(14,5)'),
				OtroImpuesto = T.N.value('OtroImpuesto[1]',		'DECIMAL(14,5)'),
				Descuento = T.N.value('Descuento[1]',			'DECIMAL(14,5)'),
				RedondeoSuma = T.N.value('RedondeoSuma[1]',		'DECIMAL(14,5)'),
				RedondeoResta = T.N.value('RedondeoResta[1]',		'DECIMAL(14,5)'),
				Total = T.N.value('Total[1]',				'DECIMAL(14,5)'),
				FlagBorrador =  T.N.value('FlagBorrador[1]',		'BIT'),
				IdDetraccion = CASE WHEN (T.N.value('IdDetraccion[1]','INT') = 0) THEN NULL ELSE T.N.value('IdDetraccion[1]', 'INT') END,
				Descripcion = T.N.value('Descripcion[1]',				'VARCHAR(MAX)'),
				ImpuestoRenta = T.N.value('ImpuestoRenta[1]',				'DECIMAL(14,5)'),
				UsuarioModifico = T.N.value('UsuarioModifico[1]',				'VARCHAR(250)'),
				FechaModificado = DATEADD(HOUR, 3, GETDATE()),
				FlagImpuestoSegundaCategoria = T.N.value('FlagImpuestoSegundaCategoria[1]',				'BIT'),
				ImpuestoRentaSegundaCategoria = T.N.value('ImpuestoRentaSegundaCategoria[1]',		'DECIMAL(14,5)')
				FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)
				WHERE ID = @IdCompra

				 ------=================================================================================------
			------=================== INSERTAR EL DETALLE DE LA COMPRA ===================------

				DELETE FROM [ERP].[CompraDetalle] WHERE IdCompra = @IdCompra

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
				CASE WHEN (T.N.value('IdOperacion[1]','INT') = 0) THEN	NULL ELSE T.N.value('IdOperacion[1]',			'INT') END	AS IdOperacion,																				
				CASE WHEN (T.N.value('IdPlanCuenta[1]','INT') = 0) THEN	NULL ELSE T.N.value('IdPlanCuenta[1]',			'INT') END	AS IdPlanCuenta,
				CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN	NULL ELSE T.N.value('IdProyecto[1]',			'INT') END	AS IdProyecto,																									
				T.N.value('Glosa[1]',				'VARCHAR(250)')		AS Nombre,										
				T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Importe,									
				T.N.value('Afecto[1]',				'BIT')				AS FlagAfecto								
				FROM @XMLCompra.nodes('/ListaArchivoPlanoCompraDetalle/ArchivoPlanoCompraDetalle')	AS T(N)

				 ------=================================================================================------
			------=================== INSERTAR LA REFERENCIA DE LA COMPRA ===================------
						
					IF(@FlagBorrador = 0)
						BEGIN
							UPDATE VA SET
								   VA.IdValeEstado = 1 /*REGISTRADO*/
							FROM ERP.Vale VA
							INNER JOIN ERP.CompraReferencia CR ON CR.IdReferencia = VA.ID
							WHERE CR.IdReferenciaOrigen = 5 AND CR.IdCompra = @IdCompra 
						END

					DELETE ERP.CompraReferencia WHERE IdCompra = @IdCompra

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
												CASE WHEN (T.N.value('IdReferenciaOrigen[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferenciaOrigen[1]'	,'INT')	END AS IdReferenciaOrigen,
												CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
												T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
												T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
												T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
												T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
												FROM @XMLCompra.nodes('/ListaArchivoPlanoCompraReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)

		------=================================================================================------
			------=================== DISPARAR TABLA ERP.CompraDetraccion ===================------
			IF @IdDetraccion != 0 AND @IdCompra NOT IN(SELECT IdCompra FROM ERP.CompraDetraccion) AND @FlagBorrador !=1
			BEGIN
			 INSERT INTO ERP.CompraDetraccion (
												IdCompra,
												IdDetraccion,
												Porcentaje,
												FechaRegistro
									)
									 SELECT 
										@IdCompra													AS IdCompra,
										T.N.value('IdDetraccion[1]',				'INT')			AS IdDetraccion,
										T.N.value('PorcentajeDetraccion[1]',	'DECIMAL(14,5)')	AS Porcentaje,	
										DATEADD(HOUR, 3, GETDATE())									AS FechaRegistro
										FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)
			END
			ELSE IF (@FlagBorrador = 0 AND @IdCompra IN(SELECT IdCompra FROM ERP.CompraDetraccion))
				UPDATE ERP.CompraDetraccion
				SET IdDetraccion =T.N.value('IdDetraccion[1]',				'INT'),
					Porcentaje = T.N.value('PorcentajeDetraccion[1]',	'DECIMAL(14,5)')
				FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)
				WHERE ID = @IdCompra

		------=================================================================================------
			------=================== DISPARAR ASIENTO CONTABLE ===================------
			DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.Compra WHERE ID = @IdCompra )
			DECLARE @IdTipoComprobanteAnticipo INT = (SELECT IdTipoComprobante FROM ERP.Compra WHERE ID = @IdCompra)
			IF @IdAsiento IS NULL
			BEGIN
			SET @IdAsiento = 0
				IF (@FlagBorrador !=1 AND @IdTipoComprobanteAnticipo ! = 183)
				BEGIN

					EXEC ERP.Usp_Ins_AsientoContable_Compra @IdAsiento OUT,@IdCompra,5 /*REGISTRO DE COMPRAS(ORIGEN)*/,4/*COMPRAS(SISTEMA)*/

					UPDATE ERP.Compra SET IdAsiento = @IdAsiento WHERE ID = @IdCompra

				END
			END
			ELSE
					EXEC [ERP].[Usp_Ins_AsientoContable_Compra_Reprocesar] @IdAsiento,@IdCompra,5 /*REGISTRO DE COMPRAS(ORIGEN)*/,4/*COMPRAS(SISTEMA)*/

		------=================================================================================------
			------=================== INSERT CUENTA PAGAR ===================------
			DECLARE @IdProveedor INT = (SELECT T.N.value('IdProveedor[1]','INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
			DECLARE @IdTipoComprobanteCompra INT = (SELECT T.N.value('IdTipoComprobante[1]','INT') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
			DECLARE @IdEntidadProveedor INT = (SELECT IdEntidad FROM ERP.Proveedor WHERE ID = @IdProveedor)
			DECLARE @IdCuentaPagar INT
			DECLARE @ComprobanteTipoDetraccion INT = (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Abreviatura = 'DET')
			DECLARE @IdReciboHonorario INT = (SELECT ID FROM PLE.T10TipoComprobante WHERE ID = 3) /*RECIBO HONORARIO*/

			DECLARE @IdTipoComprobanteCuartoCategoria INT = (SELECT ID FROM PLE.T10TipoComprobante WHERE ID = 191) /*RETENCIÓN POR CUARTA CATEGORÍA*/

			DECLARE @ImpuestoRenta DECIMAL = (SELECT T.N.value('ImpuestoRenta[1]','DECIMAL(14,5)') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))

			DECLARE @Debe INT = 1
			DECLARE @Haber INT = 2

			IF @FlagBorrador = 0 AND @IdCompra NOT IN(SELECT IdCompra FROM ERP.CompraCuentaPagar)
			BEGIN
				INSERT INTO ERP.CuentaPagar(IdEmpresa,
											IdEntidad,
											Fecha,
											IdTipoComprobante,
											Serie,
											Numero,
											Total,
											TipoCambio,
											IdMoneda,
											IdCuentaPagarOrigen,
											Flag,
											FlagDetraccion,
											FlagCancelo,
											FechaVencimiento,
											IdDebeHaber,
											FlagAnticipo,
											FechaRecepcion,
											IdPeriodo,
											FlagImpuestoRenta
											)
				SELECT
					T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
					@IdEntidadProveedor,
					T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,	
					T.N.value('IdTipoComprobante[1]',	'INT')				AS IdTipoComprobante,	
					T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,										
					T.N.value('Numero[1]',				'VARCHAR(20)')		AS Numero,	
					T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Total,					
					T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,		
					T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,	
					CAST(1 AS INT)											AS IdCuentaPagarOrigen,--Compra
					CAST(1 AS BIT)											AS Flag,
					CAST(0 AS BIT)											AS FlagDetraccion,
					CAST(0 AS BIT)											AS FlagCancelo,
					T.N.value('FechaVencimiento[1]',		'DATETIME')		AS FechaVencimiento,
					CASE WHEN (T.N.value('IdTipoComprobante[1]','INT') IN (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Nombre LIKE '%' + 'CR%')) THEN @Debe ELSE @Haber	END	AS IdDebeHaber,
					CAST(0 AS BIT)											AS FlagAnticipo,
					T.N.value('FechaRecepcion[1]',		'DATETIME')			AS FechaRecepcion,
					@IdPeriodo												AS IdPeriodo,
					CAST(0 AS BIT)											AS FlagImpuestoRenta
									
				FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)

				SET @IdCuentaPagar = SCOPE_IDENTITY()

				INSERT INTO ERP.CompraCuentaPagar (IdCompra,IdCuentaPagar) VALUES(@IdCompra,@IdCuentaPagar)
					------=================================================================================------
				------=================== INSERTAR CUENTA POR PAGAR SI TIENE RETENCIÓN A LA RENTA POR PARTE DEL RH ===================------

				IF (@IdTipoComprobanteCompra = @IdReciboHonorario AND @ImpuestoRenta != 0)
					BEGIN
							INSERT INTO ERP.CuentaPagar(IdEmpresa,
											IdEntidad,
											Fecha,
											IdTipoComprobante,
											Serie,
											Numero,
											Total,
											TipoCambio,
											IdMoneda,
											IdCuentaPagarOrigen,
											Flag,
											FlagDetraccion,
											FlagCancelo,
											FechaVencimiento,
											IdDebeHaber,
											FlagAnticipo,
											FechaRecepcion,
											IdPeriodo,
											FlagImpuestoRenta
											) 
								SELECT
									T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
									@IdEntidadProveedor,
									T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,	
									@IdTipoComprobanteCuartoCategoria						AS IdTipoComprobante,	
									T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,										
									T.N.value('Numero[1]',				'VARCHAR(20)')		AS Numero,	
									T.N.value('ImpuestoRenta[1]',		'DECIMAL(14,5)')	AS Total,					
									T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,		
									T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,	
									CAST(1 AS INT)											AS IdCuentaPagarOrigen,--Compra
									CAST(1 AS BIT)											AS Flag,
									CAST(0 AS BIT)											AS FlagDetraccion,
									CAST(0 AS BIT)											AS FlagCancelo,
									T.N.value('FechaVencimiento[1]',		'DATETIME')		AS FechaVencimiento,																
									@Haber													AS IdDebeHaber,
									CAST(0 AS BIT)											AS FlagAnticipo,
									T.N.value('FechaRecepcion[1]',		'DATETIME')			AS FechaRecepcion,
									@IdPeriodo												AS IdPeriodo,
									CAST(1 AS BIT)											AS FlagImpuestoRenta

									FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)

									SET @IdCuentaPagar = SCOPE_IDENTITY()

									INSERT INTO ERP.CompraCuentaPagar (IdCompra,IdCuentaPagar) VALUES(@IdCompra,@IdCuentaPagar)
					END


					------=================================================================================------
				------=================== INSERTAR CUENTA POR PAGAR SI TIENE DETRACCIÓN ===================------
					IF @IdDetraccion != 0
						BEGIN
							DECLARE @Porcentaje DECIMAL(14,5) = (SELECT CAST(Porcentaje AS DECIMAL(14,5)) FROM Maestro.Detraccion WHERE ID = @IdDetraccion)
							DECLARE @Total DECIMAL(14,5) = (SELECT T.N.value('Total[1]','DECIMAL(14,5)') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
							DECLARE @TotalDetraccion DECIMAL(14,5) = IIF(@Porcentaje = 1,CAST(((@Total * @Porcentaje)/100) AS INT) , ((@Total * @Porcentaje)/100))
							DECLARE @ParserDetraccionEntero INT = (SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'CPTDA',GETDATE()));

							IF @ParserDetraccionEntero = 1
							BEGIN
								SET @TotalDetraccion = CAST(@TotalDetraccion AS DECIMAL)
							END

								INSERT INTO ERP.CuentaPagar(IdEmpresa,
											IdEntidad,
											Fecha,
											IdTipoComprobante,
											Serie,
											Numero,
											Total,
											TipoCambio,
											IdMoneda,
											IdCuentaPagarOrigen,
											Flag,
											FlagDetraccion,
											FlagCancelo,
											IdDebeHaber,
											FlagAnticipo,
											FechaRecepcion,
											IdPeriodo,
											FlagImpuestoRenta
											)
								SELECT
									T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
									@IdEntidadProveedor,
									T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,	
									@ComprobanteTipoDetraccion								AS IdTipoComprobante,	
									T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,										
									T.N.value('Numero[1]',				'VARCHAR(20)')		AS Numero,	
									@TotalDetraccion										AS Total,					
									T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,		
									T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,	
									CAST(1 AS INT)											AS IdCuentaPagarOrigen,--Compra
									CAST(1 AS BIT)											AS Flag,
									CAST(1 AS BIT)											AS FlagDetraccion,
									CAST(0 AS BIT)											AS FlagCancelo,
									@Haber													AS IdDebeHaber,
									CAST(0 AS BIT)											AS FlagAnticipo,
									T.N.value('FechaRecepcion[1]',		'DATETIME')			AS FechaRecepcion,
									@IdPeriodo,
									CAST(0 AS BIT)											AS FlagImpuestoRenta
								FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)

								SET @IdCuentaPagar = SCOPE_IDENTITY()

								UPDATE CP SET 
								CP.Total = (@Total - @TotalDetraccion)
								FROM ERP.CuentaPagar CP
								INNER JOIN ERP.CompraCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
								INNER JOIN @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N) ON  CCP.IdCompra =T.N.value('ID[1]',	'INT') 
								WHERE CP.FlagDetraccion = 0 

								INSERT INTO ERP.CompraCuentaPagar (IdCompra,IdCuentaPagar) VALUES(@IdCompra,@IdCuentaPagar)

						END
			END
			ELSE IF  @FlagBorrador = 0
			BEGIN
					UPDATE CP SET 
					CP.IdEntidad = @IdEntidadProveedor,
					CP.Fecha = T.N.value('FechaEmision[1]', 'DATETIME'),
					CP.IdTipoComprobante = T.N.value('IdTipoComprobante[1]',	'INT'),
					CP.Serie = T.N.value('Serie[1]', 'CHAR(4)'),
					CP.Numero = T.N.value('Numero[1]', 'VARCHAR(20)'),
					CP.Total = T.N.value('Total[1]', 'DECIMAL(14,5)'),
					CP.TipoCambio = T.N.value('TipoCambio[1]', 'DECIMAL(14,5)'),
					CP.IdMoneda = T.N.value('IdMoneda[1]',	'INT'),
					CP.FechaVencimiento = T.N.value('FechaVencimiento[1]','DATETIME'),
					CP.IdDebeHaber = CASE WHEN (T.N.value('IdTipoComprobante[1]','INT') IN (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Nombre LIKE '%' + 'CR%')) THEN	@Debe	ELSE 	@Haber	END	,
					CP.FechaRecepcion = T.N.value('FechaRecepcion[1]', 'DATETIME'),
					CP.IdPeriodo = @IdPeriodo
					FROM ERP.CuentaPagar CP
					INNER JOIN ERP.CompraCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
					INNER JOIN @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N) ON  CCP.IdCompra =T.N.value('ID[1]',	'INT') 
					WHERE CP.FlagDetraccion = 0  AND CP.FlagImpuestoRenta = 0

						------=================================================================================------
				------=================== ACTUALIZAMOS CUENTA POR PAGAR SI VIENE DE LA RENTENCIÓN A LA RENTA POR RH ===================------
					DECLARE @IdCompraRenta INT = (SELECT CP.ID FROM ERP.CompraCuentaPagar CCP INNER JOIN ERP.Compra C ON CCP.IdCompra = C.ID
																								  INNER JOIN ERP.CuentaPagar CP ON CP.ID = CCP.IdCuentaPagar
																								  WHERE C.ID = @IdCompra AND CP.FlagImpuestoRenta = 1)

					IF(@IdCompraRenta IS NOT NULL AND (SELECT ImpuestoRenta FROM ERP.Compra WHERE ID = @IdCompra) = 0)
						BEGIN
							DELETE CCP FROM ERP.CompraCuentaPagar CCP WHERE CCP.IdCuentaPagar = @IdCompraRenta 
							DELETE CP FROM ERP.CuentaPagar CP WHERE CP.ID = @IdCompraRenta
						END

					IF(@IdCompraRenta IS NOT NULL AND (SELECT ImpuestoRenta FROM ERP.Compra WHERE ID = @IdCompra) != 0)
						BEGIN
								UPDATE CP SET 
								CP.IdEntidad = @IdEntidadProveedor,
								CP.Fecha = T.N.value('FechaEmision[1]', 'DATETIME'),
								CP.IdTipoComprobante = T.N.value('IdTipoComprobante[1]',	'INT'),
								CP.Serie = T.N.value('Serie[1]', 'CHAR(4)'),
								CP.Numero = T.N.value('Numero[1]', 'VARCHAR(20)'),
								CP.Total = T.N.value('ImpuestoRenta[1]', 'DECIMAL(14,5)'),
								CP.TipoCambio = T.N.value('TipoCambio[1]', 'DECIMAL(14,5)'),
								CP.IdMoneda = T.N.value('IdMoneda[1]',	'INT'),
								CP.FechaVencimiento = T.N.value('FechaVencimiento[1]','DATETIME'),
								CP.IdDebeHaber = @Haber,
								CP.FechaRecepcion = T.N.value('FechaRecepcion[1]', 'DATETIME'),
								CP.IdPeriodo = @IdPeriodo
								FROM ERP.CuentaPagar CP
								INNER JOIN ERP.CompraCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
								INNER JOIN @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N) ON  CCP.IdCompra =T.N.value('ID[1]',	'INT') 
								WHERE CP.FlagImpuestoRenta = 1 AND CP.ID = @IdCompraRenta

						END
					ELSE IF (@IdCompraRenta IS NULL AND (SELECT ImpuestoRenta FROM ERP.Compra WHERE ID = @IdCompra)> 0)
						BEGIN 
							INSERT INTO ERP.CuentaPagar(IdEmpresa,
											IdEntidad,
											Fecha,
											IdTipoComprobante,
											Serie,
											Numero,
											Total,
											TipoCambio,
											IdMoneda,
											IdCuentaPagarOrigen,
											Flag,
											FlagDetraccion,
											FlagCancelo,
											FechaVencimiento,
											IdDebeHaber,
											FlagAnticipo,
											FechaRecepcion,
											IdPeriodo,
											FlagImpuestoRenta
											) 
								SELECT
									T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
									@IdEntidadProveedor,
									T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,	
									@IdTipoComprobanteCuartoCategoria						AS IdTipoComprobante,	
									T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,										
									T.N.value('Numero[1]',				'VARCHAR(20)')		AS Numero,	
									T.N.value('ImpuestoRenta[1]',		'DECIMAL(14,5)')	AS Total,					
									T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,		
									T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,	
									CAST(1 AS INT)											AS IdCuentaPagarOrigen,--Compra
									CAST(1 AS BIT)											AS Flag,
									CAST(0 AS BIT)											AS FlagDetraccion,
									CAST(0 AS BIT)											AS FlagCancelo,
									T.N.value('FechaVencimiento[1]',		'DATETIME')		AS FechaVencimiento,																
									@Haber													AS IdDebeHaber,
									CAST(0 AS BIT)											AS FlagAnticipo,
									T.N.value('FechaRecepcion[1]',		'DATETIME')			AS FechaRecepcion,
									@IdPeriodo												AS IdPeriodo,
									CAST(1 AS BIT)											AS FlagImpuestoRenta
									FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)

									SET @IdCuentaPagar = SCOPE_IDENTITY()

									INSERT INTO ERP.CompraCuentaPagar (IdCompra,IdCuentaPagar) VALUES(@IdCompra,@IdCuentaPagar)
						END
				------=================================================================================------
				------=================== INSERTAR CUENTA POR PAGAR SI VIENE DE LA DETRACCIÓN ===================------
					DECLARE @IdCuentaPagarDetraccion INT = (SELECT CP.ID FROM ERP.CuentaPagar  CP INNER JOIN ERP.CompraCuentaPagar CCP ON CCP.IdCuentaPagar = CP.ID WHERE CCP.IdCompra = @IdCompra AND CP.FlagDetraccion =1)
					SET @Porcentaje = (SELECT CAST(Porcentaje AS DECIMAL(14,5)) FROM Maestro.Detraccion WHERE ID = @IdDetraccion)
					SET @Total  = (SELECT T.N.value('Total[1]','DECIMAL(14,5)') FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N))
					SET @ParserDetraccionEntero = (SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'CPTDA',GETDATE()));
					SET @TotalDetraccion = ((@Total * @Porcentaje)/100)

					IF @ParserDetraccionEntero = 1
					BEGIN
						SET @TotalDetraccion = CAST(@TotalDetraccion AS DECIMAL)
					END

					IF (@IdCuentaPagarDetraccion !=0)
					BEGIN
						UPDATE CP SET 
								CP.IdEntidad = @IdEntidadProveedor,
								CP.Fecha = T.N.value('FechaEmision[1]',		'DATETIME'),
								CP.IdTipoComprobante = @ComprobanteTipoDetraccion,
								CP.Serie = T.N.value('Serie[1]',				'CHAR(4)'),
								CP.Numero = T.N.value('Numero[1]',				'VARCHAR(20)'),
								CP.Total = @TotalDetraccion,
								CP.TipoCambio = T.N.value('TipoCambio[1]',			'DECIMAL(14,5)'),
								CP.IdMoneda = T.N.value('IdMoneda[1]',			'INT'),
								CP.FechaVencimiento = T.N.value('FechaVencimiento[1]','DATETIME'),
								CP.IdDebeHaber = @Haber,
								CP.FechaRecepcion = T.N.value('FechaRecepcion[1]', 'DATETIME'),
								CP.IdPeriodo = @IdPeriodo
						FROM ERP.CuentaPagar CP
						INNER JOIN ERP.CompraCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
						INNER JOIN @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N) ON  CCP.IdCompra =T.N.value('ID[1]',	'INT') 
						WHERE CP.ID = @IdCuentaPagarDetraccion

						UPDATE CP SET 
								CP.Total = (@Total - @TotalDetraccion)
								FROM ERP.CuentaPagar CP
								INNER JOIN ERP.CompraCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
								INNER JOIN @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N) ON  CCP.IdCompra =T.N.value('ID[1]',	'INT') 
								WHERE CP.FlagDetraccion = 0 AND CP.FlagImpuestoRenta = 0

					END
					ELSE IF @IdDetraccion != 0 
					BEGIN
						INSERT INTO ERP.CuentaPagar(IdEmpresa,
											IdEntidad,
											Fecha,
											IdTipoComprobante,
											Serie,
											Numero,
											Total,
											TipoCambio,
											IdMoneda,
											IdCuentaPagarOrigen,
											Flag,
											FlagDetraccion,
											FlagCancelo,
											FechaVencimiento,
											IdDebeHaber,
											FlagAnticipo,
											FechaRecepcion,
											IdPeriodo,
											FlagImpuestoRenta
											)
								SELECT
									T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
									@IdEntidadProveedor,
									T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,	
									@ComprobanteTipoDetraccion				AS IdTipoComprobante,	
									T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,										
									T.N.value('Numero[1]',				'VARCHAR(20)')		AS Numero,	
									@TotalDetraccion										AS Total,					
									T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,		
									T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,	
									CAST(1 AS INT)											AS IdCuentaPagarOrigen,--Compra
									CAST(1 AS BIT)											AS Flag,
									CAST(1 AS BIT)											AS FlagDetraccion,
									CAST(0 AS BIT)											AS FlagCancelo,
									T.N.value('FechaVencimiento[1]','DATETIME')				AS FechaVencimiento,
									@Haber													AS IdDebeHaber,
									CAST(0 AS BIT)											AS FlagAnticipo,
									T.N.value('FechaRecepcion[1]', 'DATETIME')				AS FechaRecepcion,
									@IdPeriodo,
									CAST(0 AS BIT)											AS FlagImpuestoRenta
								FROM @XMLCompra.nodes('/ArchivoPlanoCompra')	AS T(N)
								SET @IdCuentaPagar = SCOPE_IDENTITY()

								UPDATE CP SET 
								CP.Total = (@Total - @TotalDetraccion),
								CP.IdPeriodo = @IdPeriodo
								FROM ERP.CuentaPagar CP
								INNER JOIN ERP.CompraCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
								INNER JOIN @XMLCompra.nodes('/ArchivoPlanoCompra') AS T(N) ON  CCP.IdCompra =T.N.value('ID[1]',	'INT') 
								WHERE CP.FlagDetraccion = 0 AND CP.FlagImpuestoRenta = 0

								INSERT INTO ERP.CompraCuentaPagar (IdCompra,IdCuentaPagar) VALUES(@IdCompra,@IdCuentaPagar)
					END
			END
END