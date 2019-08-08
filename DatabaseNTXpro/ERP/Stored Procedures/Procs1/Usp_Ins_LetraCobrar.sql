

CREATE PROC [ERP].[Usp_Ins_LetraCobrar]
@XMLLetraCobrar XML
AS
BEGIN

		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @IdLetraCobrar INT;
		DECLARE @IdCuentaCobrarDebe INT;
		DECLARE @IdCuentaCobrarHaber INT;
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		

		DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('Indice[1]','INT')) FROM @XMLLetraCobrar.nodes('/ListaArchivoPlanoLetraCobrar/ArchivoPlanoLetraCobrar') AS T(N))
		DECLARE @i INT = 1;
		WHILE @i <= @TOTAL_ITEMS
		BEGIN
			-----INSERTAR LETRA COBRAR
			INSERT INTO ERP.LetraCobrar(
										IdCliente,
										IdEmpresa,
										IdMoneda,
										FechaEmision,
										FechaVencimiento,
										Serie,
										Numero,
										DiasVencimiento,
										Porcentaje,
										Monto,
										UsuarioRegistro,
										FechaRegistro
										)
			SELECT 
					CASE WHEN T.N.value('IdCliente[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdCliente[1]','INT') END AS IdCliente,
					CASE WHEN T.N.value('IdEmpresa[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdEmpresa[1]','INT') END AS IdEmpresa,
					CASE WHEN T.N.value('IdMoneda[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdMoneda[1]','INT') END AS IdMoneda,
					T.N.value('FechaEmision[1]',			'DATETIME')				AS FechaEmision,
					T.N.value('FechaVencimiento[1]',			'DATETIME')			AS FechaVencimiento,
					T.N.value('Serie[1]',			'VARCHAR(8)')					AS Serie,
					T.N.value('Numero[1]',			'VARCHAR(8)')				AS Numero,
					T.N.value('IntervaloDias[1]',			'INT')					AS DiasVencimiento,
					T.N.value('Porcentaje[1]',			'DECIMAL(14,5)')		AS Porcentaje,
					T.N.value('Monto[1]',					'DECIMAL(14,5)')		AS Monto,
					T.N.value('UsuarioRegistro[1]',			'VARCHAR(250)')		AS UsuarioRegistro,
					@FechaActual													AS FechaRegistro
			FROM @XMLLetraCobrar.nodes('/ListaArchivoPlanoLetraCobrar/ArchivoPlanoLetraCobrar')	AS T(N)
			WHERE T.N.value('Indice[1]','INT') = @i;

			SET @IdLetraCobrar = SCOPE_IDENTITY();

			-----INSERTAR CUENTA COBRAR DEBE
			INSERT INTO ERP.CuentaCobrar(IdEmpresa,
								IdEntidad,
								Fecha,
								IdTipoComprobante,
								Serie,
								Numero,
								Total,
								TipoCambio,
								IdMoneda,
								IdCuentaCobrarOrigen,
								Flag,
								FlagCancelo,
								IdDebeHaber,
								FechaVencimiento,
								FechaRecepcion,
								FlagAnticipo
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
					CAST(0 AS BIT)											AS FlagAnticipo
				FROM ERP.LetraCobrar LC
				INNER JOIN ERP.Cliente CLI ON CLI.ID = LC.IdCliente
				INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
				WHERE LC.ID = @IdLetraCobrar

				SET @IdCuentaCobrarDebe = SCOPE_IDENTITY();

				INSERT INTO ERP.LetraCobrarCuentaCobrar(IdLetraCobrar, IdCuentaCobrar)
				VALUES(@IdLetraCobrar, @IdCuentaCobrarDebe)

				-----INSERTAR CUENTA COBRAR HABER
				INSERT INTO ERP.CuentaCobrar(IdEmpresa,
									IdEntidad,
									Fecha,
									IdTipoComprobante,
									Serie,
									Numero,
									Total,
									TipoCambio,
									IdMoneda,
									IdCuentaCobrarOrigen,
									Flag,
									FlagCancelo,
									IdDebeHaber,
									FechaVencimiento,
									FechaRecepcion,
									FlagAnticipo
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
						CAST(0 AS BIT)											AS FlagAnticipo
					FROM ERP.LetraCobrar LC
					INNER JOIN ERP.Cliente CLI ON CLI.ID = LC.IdCliente
					INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
					WHERE LC.ID = @IdLetraCobrar

					SET @IdCuentaCobrarHaber = SCOPE_IDENTITY();

					INSERT INTO ERP.LetraCobrarCuentaCobrar(IdLetraCobrar, IdCuentaCobrar)
					VALUES(@IdLetraCobrar, @IdCuentaCobrarHaber)

				SET @i = @i + 1;
		END
END
