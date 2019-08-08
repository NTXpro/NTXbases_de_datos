CREATE PROC [ERP].[Usp_Ins_AplicacionAnticipoCobrar]
@IdAplicacionAnticipo	 INT OUTPUT,
@XMLAplicacionAnticipo	 XML
AS
BEGIN
	
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;


		DECLARE @IdCuentaCobrar INT = (SELECT T.N.value('IdCuentaCobrar[1]',	'INT')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N));

		DECLARE @IdTipoComprobante INT = (SELECT T.N.value('IdTipoComprobante[1]',	'INT')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N))

		DECLARE @FechaAnticipo DATE ; 

		iF(@IdTipoComprobante = 183 OR @IdTipoComprobante = 8)
			BEGIN
				SET @FechaAnticipo = (SELECT MAX(T.N.value('Fecha[1]',	'DATETIME')) FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N))
			END
		ELSE
			BEGIN
				SET @FechaAnticipo = (CAST((SELECT T.N.value('Fecha[1]',	'DATETIME')	FROM  @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N)) AS DATE))
			END

		INSERT INTO ERP.AplicacionAnticipoCobrar(
													IdCuentaCobrar,
													IdCliente,
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
						T.N.value('IdCuentaCobrar[1]',			'INT')				AS IdCuentaCobrar,
						T.N.value('IdCliente[1]',				'INT')				AS IdCliente,
						T.N.value('IdMoneda[1]',				'INT')				AS IdMoneda,
						T.N.value('IdTipoComprobante[1]',		'INT')				AS IdTipoComprobante,
						T.N.value('Documento[1]',		'VARCHAR(20)')				AS Documento,
						T.N.value('Serie[1]',				'CHAR(4)')				AS Serie,
						@FechaAnticipo												AS Fecha,
						T.N.value('TipoCambio[1]',	'DECIMAL(14,5)')				AS TipoCambio,
						T.N.value('Total[1]',		'DECIMAL(14,5)')				AS Total,
						DATEADD(HOUR, 3, GETDATE())									AS FechaRegistro,
						T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')			AS UsuarioRegistro,
						T.N.value('IdEmpresa[1]',			'INT')					AS IdEmpresa,
						CAST(1 AS BIT)												AS Flag,
						@FechaAnticipo												AS FechaAplicacion

				FROM @XMLAplicacionAnticipo.nodes('/ArchivoPlanoAplicacionAnticipo') AS T(N)

				SET @IdAplicacionAnticipo = SCOPE_IDENTITY();

				UPDATE ERP.CuentaCobrar SET FlagAnticipo = 1 WHERE ID = @IdCuentaCobrar
				/********************************INSERTAMOS EL DETALLE*****************************/
				INSERT INTO ERP.AplicacionAnticipoCobrarDetalle(
																IdAplicacionAnticipoCobrar,
																IdCuentaCobrar,
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
																T.N.value('IdCuentaCobrar[1]',				'INT')					AS IdCuentaCobrar,	
																T.N.value('IdTipoComprobante[1]',			'INT')					AS IdTipoComprobante,	
																T.N.value('IdMoneda[1]',					'INT')					AS IdMoneda,	
																T.N.value('Documento[1]',				'VARCHAR(20)')				AS Documento,	
																T.N.value('Serie[1]',						'CHAR(4)')				AS Serie,	
																T.N.value('Fecha[1]',				'DATETIME')						AS Fecha,	
																T.N.value('Total[1]',				'DECIMAL(14,5)')				AS Total,
																T.N.value('TotalAplicado[1]',		'DECIMAL(14,5)')				AS TotalAplicado,
																1																	AS IdDebeHaber
																FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N)
			/*********************************************************************************************/


			/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR  CABECERA*****************************/
				UPDATE ERP.CuentaCobrar SET FlagCancelo = 1 
											WHERE ID = @IdCuentaCobrar AND 
											(CASE WHEN IdMoneda = 1 THEN
												(SELECT ERP.SaldoTotalCuentaCobrarDeSoles(ID))
											ELSE
												(SELECT ERP.SaldoTotalCuentaCobrarDeDolares(ID))
											END)  = 0;


			/*********************************************************************************************/

			/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR DETALLE*****************************/
					DECLARE @ListaIdCuentaCobrarDetale TABLE(INDICE INT,ID INT)

					INSERT INTO @ListaIdCuentaCobrarDetale
					SELECT ROW_NUMBER() OVER(ORDER BY T.N.value('IdCuentaCobrar[1]','INT') ASC),T.N.value('IdCuentaCobrar[1]','INT') FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N)


					DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('IdCuentaCobrar[1]','INT')) FROM @XMLAplicacionAnticipo.nodes('/ListaArchivoPlanoAplicacionAnticipoPagarDetalle/ArchivoPlanoAplicacionAnticipoPagarDetalle')AS T(N))

					DECLARE @i INT = 1;
						WHILE @i <= @TOTAL_ITEMS
						BEGIN
								
								DECLARE @IdCuentaCobrarDetalle INT = (SELECT ID FROM @ListaIdCuentaCobrarDetale WHERE INDICE = @i)

										UPDATE ERP.CuentaCobrar SET FlagCancelo = 1 
											WHERE ID = @IdCuentaCobrarDetalle AND 
											(CASE WHEN IdMoneda = 1 THEN
												(SELECT ERP.SaldoTotalCuentaCobrarDeSoles(ID))
											ELSE
												(SELECT ERP.SaldoTotalCuentaCobrarDeDolares(ID))
											END)  = 0;

						SET @i = @i + 1

					END
				/*********************************************************************************************/



			/********************************INSERTAMOS EL ASIENTO CONTABLE*****************************/


			DECLARE @IdAsiento INT ;

			EXEC ERP.Usp_Ins_AsientoContable_CuentaCobrar @IdAsiento OUT , @IdAplicacionAnticipo ,8 /*CUENTAS POR COBRAR(ORIGEN)*/,2 /*VENTAS (SISTEMA)*/

			UPDATE ERP.AplicacionAnticipoCobrar SET IdAsiento = @IdAsiento WHERE ID = @IdAplicacionAnticipo 

			/*********************************************************************************************/
		SET NOCOUNT OFF;
END