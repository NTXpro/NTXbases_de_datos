
CREATE PROC [ERP].[Usp_Ins_AplicacionAnticipoPagar]
@IdAplicacionAnticipo	 INT OUTPUT,
@XMLAplicacionAnticipo	 XML
AS 
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @IdCuentaPagar INT = (SELECT T.N.value('IdCuentaPagar[1]',	'INT')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N));

		DECLARE @IdTipoComprobante INT = (SELECT T.N.value('IdTipoComprobante[1]',	'INT')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N))
		DECLARE @FechaRecepcion DATETIME = (SELECT FechaRecepcion FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar); 
		DECLARE @FechaAnticipo DATETIME; 
		DECLARE @TipoCambio DECIMAL(14,5);
		DECLARE @ID INT ; 


		iF(@IdTipoComprobante = 183)
			BEGIN
				SET @FechaAnticipo = (SELECT MAX(T.N.value('Fecha[1]',	'DATETIME')) FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N))
				SET @ID = (SELECT T.N.value('IdCuentaPagar[1]',	'INT') FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N) WHERE T.N.value('Fecha[1]','DATETIME') = @FechaAnticipo)
				SET @TipoCambio = (SELECT T.N.value('TipoCambio[1]',	'DECIMAL(14,5)')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N))
				SET @FechaRecepcion = @FechaAnticipo;
			END
		ELSE
			BEGIN
				SET @FechaAnticipo = (CAST((SELECT T.N.value('Fecha[1]',	'DATETIME')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N)) AS DATE))
				SET @TipoCambio = (SELECT T.N.value('TipoCambio[1]',	'DECIMAL(14,5)')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N))
			END


		INSERT INTO ERP.AplicacionAnticipoPagar(	
													IdCuentaPagar,
													IdProveedor,
													IdMoneda,
													IdTipoComprobante,
													Documento,
													Serie,
													Fecha,
													TipoCambio,
													Total,
													FechaRegistro,
													UsuarioRegistro,
													IdEmpresa,
													Flag,
													FechaAplicacion
													)
					SELECT
						T.N.value('IdCuentaPagar[1]',			'INT')				AS IdCuentaPagar,
						T.N.value('IdProveedor[1]',				'INT')				AS IdProveedor,
						T.N.value('IdMoneda[1]',				'INT')				AS IdMoneda,
						T.N.value('IdTipoComprobante[1]',		'INT')				AS IdTipoComprobante,
						T.N.value('Documento[1]',		'VARCHAR(20)')				AS Documento,
						T.N.value('Serie[1]',				'CHAR(4)')				AS Serie,
						@FechaRecepcion												AS Fecha,
						@TipoCambio													AS TipoCambio,
						T.N.value('Total[1]',		'DECIMAL(14,5)')				AS Total,
						DATEADD(HOUR, 3, GETDATE())									AS FechaRegistro,
						T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')			AS UsuarioRegistro,
						T.N.value('IdEmpresa[1]',			'INT')					AS IdEmpresa,
						CAST(1 AS BIT)												AS Flag,
						@FechaRecepcion												AS FechaAplicacion

				FROM @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N)

				SET @IdAplicacionAnticipo = SCOPE_IDENTITY();

				UPDATE ERP.CuentaPagar SET FlagAnticipo = 1 WHERE ID = @IdCuentaPagar

				/********************************INSERTAMOS EL DETALLE*****************************/
				INSERT INTO ERP.AplicacionAnticipoPagarDetalle(
																IdAplicacionAnticipo,
																IdCuentaPagar,
																IdTipoComprobante,
																IdMoneda,
																Documento,
																Serie,
																Fecha,
																Total,
																TotalAplicado,
																IdDebeHaber
																)
																SELECT
																@IdAplicacionAnticipo												AS IdAplicacionAnticipo,
																T.N.value('IdCuentaPagar[1]',				'INT')					AS IdCuentaPagar,	
																T.N.value('IdTipoComprobante[1]',			'INT')					AS IdTipoComprobante,	
																T.N.value('IdMoneda[1]',					'INT')					AS IdMoneda,	
																T.N.value('Documento[1]',				'VARCHAR(20)')				AS Documento,	
																T.N.value('Serie[1]',						'CHAR(4)')				AS Serie,	
																T.N.value('Fecha[1]',				'DATETIME')						AS Fecha,	
																T.N.value('Total[1]',				'DECIMAL(14,5)')				AS Total,
																T.N.value('TotalAplicado[1]',		'DECIMAL(14,5)')				AS TotalAplicado,
																2																	AS IdDebeHaber
																FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N)
				
				/*********************************************************************************************/
				
				/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR  CABECERA*****************************/
				UPDATE ERP.CuentaPagar SET FlagCancelo = 1 
											WHERE ID = @IdCuentaPagar AND 
											(CASE WHEN IdMoneda = 1 THEN
												(SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](ID))
											ELSE
												(SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](ID))
											END)  = 0;


				/*********************************************************************************************/

				/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR DETALLE*****************************/
					DECLARE @ListaIdCuentaPagarDetale TABLE(INDICE INT,ID INT)

					INSERT INTO @ListaIdCuentaPagarDetale
					SELECT ROW_NUMBER() OVER(ORDER BY T.N.value('IdCuentaPagar[1]','INT') ASC),T.N.value('IdCuentaPagar[1]','INT') FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N)


					DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('IdCuentaPagar[1]','INT')) FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N))

					DECLARE @i INT = 1;
						WHILE @i <= @TOTAL_ITEMS
						BEGIN
								
								DECLARE @IdCuentaPagarDetalle INT = (SELECT ID FROM @ListaIdCuentaPagarDetale WHERE INDICE = @i)

										UPDATE ERP.CuentaPagar SET FlagCancelo = 1 
											WHERE ID = @IdCuentaPagarDetalle AND 
											(CASE WHEN IdMoneda = 1 THEN
												(SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](ID))
											ELSE
												(SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](ID))
											END)  = 0;

						SET @i = @i + 1

					END
				/*********************************************************************************************/


				/********************************INSERTAMOS EL ASIENTO CONTABLE*****************************/
				DECLARE @IdAsiento INT ;

				EXEC ERP.Usp_Ins_AsientoContable_CuentaPagar @IdAsiento OUT , @IdAplicacionAnticipo ,7 /*CUENTAS POR PAGAR(ORIGEN)*/,4 /*COMPRAS(SISTEMA)*/

				UPDATE ERP.AplicacionAnticipoPagar SET IdAsiento = @IdAsiento WHERE ID = @IdAplicacionAnticipo 

				/*********************************************************************************************/

				SET NOCOUNT OFF;

END
