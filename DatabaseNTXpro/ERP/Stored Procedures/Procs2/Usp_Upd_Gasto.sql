CREATE PROC [ERP].[Usp_Upd_Gasto]
@ID INT,
@IdProveedor INT,
@IdProyecto INT,
@IdEmpresa INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@IdPeriodo INT,
@TipoCambio DECIMAL(14,5),
@Serie VARCHAR(8),
@Documento VARCHAR(10),
@Descripcion VARCHAR(250),
@FechaEmision DATETIME,
@Total DECIMAL(14,5),
@Flag BIT,
@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
		DECLARE @IdAnio INT = YEAR(@FechaEmision);
		DECLARE @IdMes INT = MONTH(@FechaEmision)

		DECLARE @Orden INT = (SELECT ERP.GenerarOrdenGasto(@IdTipoComprobante,@IdMes,@IdAnio))

		--SET @Documento = (SELECT ERP.GenerarDocumentoGasto(@IdTipoComprobante,@IdMes,@IdAnio))
			
		UPDATE ERP.Gasto SET	  IdProveedor = CASE WHEN @IdProveedor = 0 THEN
											NULL
								  ELSE
											@IdProveedor
								  END, 
								  IdProyecto = CASE WHEN @IdProyecto = 0 THEN
											NULL
								  ELSE
											@IdProyecto
								  END,
								  IdEmpresa = @IdEmpresa,
								  IdTipoComprobante = @IdTipoComprobante , 
								  IdMoneda = @IdMoneda ,
								  IdPeriodo = @IdPeriodo , 
								  TipoCambio = @TipoCambio , 
								  Serie = @Serie , 
								  Documento = CASE WHEN @FlagBorrador = CAST(0 AS BIT) THEN
											@Documento
								  ELSE
											NULL
								  END ,
								  Descripcion = @Descripcion,
								  Total = @Total , 
								  Flag = @Flag , 
								  UsuarioModifico = @UsuarioModifico , 
								  FechaModificado = DATEADD(HOUR, 3, GETDATE()), 
								  FlagBorrador = @FlagBorrador,
								  FechaEmision = @FechaEmision,
								  Orden = CASE WHEN @FlagBorrador = CAST(0 AS BIT) THEN
											@Orden
								  ELSE
											NULL
								  END
				WHERE ID = @ID

			DECLARE @IdCuentaPagar INT ; 

			IF(@FlagBorrador = 0 AND @ID NOT IN (SELECT IdGasto FROM ERP.GastoCuentaPagar))
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
										FlagCancelo,
										FlagDetraccion,
										FechaVencimiento,
										IdDebeHaber,
										FlagAnticipo,
										FechaRecepcion,
										IdPeriodo)
								SELECT	GA.IdEmpresa,
										ENT.ID,
										GA.FechaEmision,
										GA.IdTipoComprobante,
										GA.Serie,
										GA.Documento,
										GA.Total,
										GA.TipoCambio,
										GA.IdMoneda,
										1,
										CAST(1 AS BIT),
										CAST(0 AS BIT),
										CAST(0 AS BIT),
										GA.FechaEmision,
										2,
										CAST(0 AS BIT),
										GA.FechaEmision,
										GA.IdPeriodo
								FROM ERP.Gasto GA
								INNER JOIN ERP.Proveedor PRO
								ON PRO.ID = GA.IdProveedor
								INNER JOIN ERP.Entidad ENT
								ON ENT.ID = PRO.IdEntidad
								WHERE GA.ID = @ID

					SET @IdCuentaPagar = SCOPE_IDENTITY()
				
					INSERT INTO ERP.GastoCuentaPagar (IdGasto,IdCuentaPagar) VALUES(@ID,@IdCuentaPagar)
				END
			ELSE
				BEGIN
							UPDATE CP SET
							CP.IdEntidad = ENT.ID,
							CP.Fecha = GA.FechaEmision,
							CP.IdTipoComprobante = GA.IdTipoComprobante,
							CP.Serie = GA.Serie,
							CP.Numero = GA.Documento,
							CP.Total = GA.Total,
							CP.TipoCambio = GA.TipoCambio,
							CP.IdMoneda = GA.IdMoneda,
							CP.FechaVencimiento = GA.FechaEmision,
							CP.FechaRecepcion = GA.FechaEmision,
							CP.IdPeriodo = GA.IdPeriodo
							FROM ERP.CuentaPagar CP
							INNER JOIN ERP.GastoCuentaPagar GCP
							ON GCP.IdCuentaPagar = CP.ID
							INNER JOIN ERP.Gasto GA
							ON GA.ID = GCP.IdGasto
							INNER JOIN ERP.Proveedor PRO
							ON PRO.ID = GA.IdProveedor
							INNER JOIN ERP.Entidad ENT
							ON ENT.ID = PRO.IdEntidad
							WHERE GA.ID = @ID
				END
				
				
END
