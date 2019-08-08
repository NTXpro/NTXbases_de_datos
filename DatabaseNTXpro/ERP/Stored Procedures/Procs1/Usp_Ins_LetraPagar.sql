
CREATE PROC [ERP].[Usp_Ins_LetraPagar]
@XMLLetraPagar XML
AS
BEGIN

		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @IdLetraPagar INT;
		DECLARE @IdCuentaPagarDebe INT;
		DECLARE @IdCuentaPagarHaber INT;
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @FechaEmision DATETIME = (SELECT TOP 1 T.N.value('FechaEmision[1]','DATETIME') FROM @XMLLetraPagar.nodes('/ListaArchivoPlanoLetraPagar/ArchivoPlanoLetraPagar') AS T(N));
		DECLARE @IdPeriodo INT = (SELECT [ERP].[ObtenerIdPeriodo_By_Fecha](@FechaEmision))

		DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('Indice[1]','INT')) FROM @XMLLetraPagar.nodes('/ListaArchivoPlanoLetraPagar/ArchivoPlanoLetraPagar') AS T(N))
		DECLARE @i INT = 1;
		WHILE @i <= @TOTAL_ITEMS
		BEGIN
			-----INSERTAR LETRA Pagar
			INSERT INTO ERP.LetraPagar(
										IdProveedor,
										IdEmpresa,
										FechaEmision,
										FechaVencimiento,
										IdMoneda,
										Serie,
										Numero,
										DiasVencimiento,
										Porcentaje,
										Monto,
										UsuarioRegistro,
										FechaRegistro
										)
			SELECT 
					CASE WHEN T.N.value('IdProveedor[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdProveedor[1]','INT') END AS IdProveedor,
					CASE WHEN T.N.value('IdEmpresa[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdEmpresa[1]','INT') END AS IdEmpresa,
					T.N.value('FechaEmision[1]',			'DATETIME')				AS FechaEmision,
					T.N.value('FechaVencimiento[1]',			'DATETIME')			AS FechaVencimiento,
					T.N.value('IdMoneda[1]',			'INT')						AS IdMoneda,
					T.N.value('Serie[1]',			'VARCHAR(8)')					AS Serie,
					T.N.value('Numero[1]',			'VARCHAR(8)')				AS Numero,
					T.N.value('IntervaloDias[1]',			'INT')					AS DiasVencimiento,
					T.N.value('Porcentaje[1]',			'DECIMAL(14,5)')		AS Porcentaje,
					T.N.value('Monto[1]',					'DECIMAL(14,5)')		AS Monto,
					T.N.value('UsuarioRegistro[1]',			'VARCHAR(250)')		AS UsuarioRegistro,
					@FechaActual													AS FechaRegistro
			FROM @XMLLetraPagar.nodes('/ListaArchivoPlanoLetraPagar/ArchivoPlanoLetraPagar')	AS T(N)
			WHERE T.N.value('Indice[1]','INT') = @i;

			SET @IdLetraPagar = SCOPE_IDENTITY();

			-----INSERTAR CUENTA PAGAR
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
								FlagCancelo,
								IdDebeHaber,
								FechaVencimiento,
								FechaRecepcion,
								FlagAnticipo,
								IdPeriodo
								)
				SELECT
					LC.IdEmpresa,
					E.ID,
					LC.FechaEmision,
					178,--LETRA
					LC.Serie,
					LC.Numero,
					LC.Monto,
					(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',LC.FechaEmision)),
					LC.IdMoneda,--SOLES
					CAST(3 AS INT)											AS IdCuentaPagarOrigen,
					CAST(1 AS BIT)											AS Flag,
					CAST(0 AS BIT)											AS FlagCancelo,
					CAST(1 AS INT)											AS IdDebeHaber,
					LC.FechaVencimiento,
					LC.FechaEmision,
					CAST(0 AS BIT)											AS FlagAnticipo,
					@IdPeriodo													AS IdPeriodo
				FROM ERP.LetraPagar LC
				INNER JOIN ERP.Proveedor P ON P.ID = LC.IdProveedor
				INNER JOIN ERP.Entidad E ON E.ID = P.IdEntidad
				WHERE LC.ID = @IdLetraPagar

				SET @IdCuentaPagarDebe = SCOPE_IDENTITY();

				INSERT INTO ERP.LetraPagarCuentaPagar(IdLetraPagar, IdCuentaPagar)
				VALUES(@IdLetraPagar, @IdCuentaPagarDebe)

				-----INSERTAR CUENTA HABER
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
									FlagCancelo,
									IdDebeHaber,
									FechaVencimiento,
									FechaRecepcion,
									FlagAnticipo,
									IdPeriodo
									)
					SELECT
						LC.IdEmpresa,
						E.ID,
						LC.FechaEmision,
						178,--LETRA
						LC.Serie,
						LC.Numero,
						LC.Monto,
						(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',LC.FechaEmision)),
						LC.IdMoneda,--SOLES
						CAST(3 AS INT)											AS IdCuentaPagarOrigen,
						CAST(1 AS BIT)											AS Flag,
						CAST(0 AS BIT)											AS FlagCancelo,
						CAST(2 AS INT)											AS IdDebeHaber,
						LC.FechaVencimiento,
						LC.FechaEmision,
						CAST(0 AS BIT)											AS FlagAnticipo,
						@IdPeriodo													AS IdPeriodo
					FROM ERP.LetraPagar LC
					INNER JOIN ERP.Proveedor P ON P.ID = LC.IdProveedor
					INNER JOIN ERP.Entidad E ON E.ID = P.IdEntidad
					WHERE LC.ID = @IdLetraPagar

					SET @IdCuentaPagarHaber = SCOPE_IDENTITY();

					INSERT INTO ERP.LetraPagarCuentaPagar(IdLetraPagar, IdCuentaPagar)
					VALUES(@IdLetraPagar, @IdCuentaPagarHaber)

				SET @i = @i + 1;
		END
END
