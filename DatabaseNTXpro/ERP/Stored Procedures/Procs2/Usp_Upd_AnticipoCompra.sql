CREATE PROC [ERP].[Usp_Upd_AnticipoCompra]
@ID INT,
@IdProveedor INT,
@IdEmpresa INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@IdPeriodo INT,
@FechaEmision DATETIME,
@TipoCambio DECIMAL(14,5),
@Serie VARCHAR(8),
@Documento VARCHAR(10),
@Descripcion VARCHAR(250),
@Total DECIMAL(14,5),
@Flag BIT,
@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
		DECLARE @IdAnio INT = YEAR(@FechaEmision);
		DECLARE @IdMes INT = MONTH(@FechaEmision)

		DECLARE @Orden INT = (SELECT ERP.GenerarOrdenAnticipo(@IdTipoComprobante,@IdMes,@IdAnio))
		SET @Documento = (SELECT Documento FROM ERP.AnticipoCompra WHERE ID = @ID )

		
		UPDATE ERP.AnticipoCompra SET IdProveedor = CASE WHEN @IdProveedor = 0 THEN NULL ELSE @IdProveedor
									  END , IdEmpresa = @IdEmpresa , 
									  IdTipoComprobante = @IdTipoComprobante , 
									  IdMoneda = @IdMoneda ,
									  IdPeriodo = @IdPeriodo , 
									  TipoCambio = @TipoCambio , 
									  Serie = @Serie , 
									  Descripcion = @Descripcion,
									  Total = @Total , 
									  Flag = @Flag , 
									  UsuarioModifico = @UsuarioModifico , 
									  FechaModificado = DATEADD(HOUR, 3, GETDATE()), 
									  FlagBorrador = @FlagBorrador,
									  FechaEmision = @FechaEmision,
									  Orden = CASE WHEN @FlagBorrador = CAST(0 AS BIT) THEN @Orden ELSE NULL  END
				WHERE ID = @ID

		IF(@FlagBorrador = 0)
		BEGIN
			IF(@Documento IS NULL)
			SET @Documento = (SELECT ERP.GenerarDocumentoAnticipoCompra(@IdTipoComprobante,@IdMes,@IdAnio)) 
			UPDATE ERP.AnticipoCompra SET Documento = @Documento WHERE ID = @ID			
		END


			DECLARE @IdCuentaPagar INT ; 

			IF(@FlagBorrador = 0 AND @ID NOT IN (SELECT IdAnticipo FROM ERP.AnticipoCompraCuentaPagar))
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
								SELECT	AN.IdEmpresa,
										ENT.ID,
										AN.FechaEmision,
										AN.IdTipoComprobante,
										AN.Serie,
										AN.Documento,
										AN.Total,
										AN.TipoCambio,
										AN.IdMoneda,
										1,
										CAST(1 AS BIT),
										CAST(0 AS BIT),
										CAST(0 AS BIT),
										AN.FechaEmision,
										2,
										CAST(0 AS BIT),
										AN.FechaEmision,
										AN.IdPeriodo
								FROM ERP.AnticipoCompra AN
								INNER JOIN ERP.Proveedor PRO
								ON PRO.ID = AN.IdProveedor
								INNER JOIN ERP.Entidad ENT
								ON ENT.ID = PRO.IdEntidad
								WHERE AN.ID = @ID

					SET @IdCuentaPagar = SCOPE_IDENTITY()
				
					INSERT INTO ERP.AnticipoCompraCuentaPagar (IdAnticipo,IdCuentaPagar) VALUES(@ID,@IdCuentaPagar)
				END
			ELSE
				BEGIN
							UPDATE CP SET
							CP.IdEntidad = ENT.ID,
							CP.Fecha = AN.FechaEmision,
							CP.IdTipoComprobante = AN.IdTipoComprobante,
							CP.Serie = AN.Serie,
							CP.Numero = AN.Documento,
							CP.Total = AN.Total,
							CP.TipoCambio = AN.TipoCambio,
							CP.IdMoneda = AN.IdMoneda,
							CP.FechaVencimiento = AN.FechaEmision,
							CP.FechaRecepcion = AN.FechaEmision,
							CP.IdPeriodo = AN.IdPeriodo
							FROM ERP.CuentaPagar CP
							INNER JOIN ERP.AnticipoCompraCuentaPagar ANCP
							ON ANCP.IdCuentaPagar = CP.ID
							INNER JOIN ERP.AnticipoCompra AN
							ON AN.ID = ANCP.IdAnticipo
							INNER JOIN ERP.Proveedor PRO
							ON PRO.ID = AN.IdProveedor
							INNER JOIN ERP.Entidad ENT
							ON ENT.ID = PRO.IdEntidad
							WHERE AN.ID = @ID
				END
				
				
END