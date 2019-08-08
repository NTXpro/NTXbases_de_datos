
CREATE PROC [ERP].[Usp_Upd_AnticipoVenta]
@ID INT,
@IdCliente INT,
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
		SET @Documento = (SELECT Documento FROM ERP.AnticipoVenta WHERE ID = @ID )

		
		UPDATE ERP.AnticipoVenta SET IdCliente = CASE WHEN @IdCliente = 0 THEN NULL ELSE @IdCliente
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
			SET @Documento = (SELECT ERP.GenerarDocumentoAnticipoVenta(@IdTipoComprobante,@IdMes,@IdAnio)) 
			UPDATE ERP.AnticipoVenta SET Documento = @Documento WHERE ID = @ID			
		END


			DECLARE @IdCuentaCobrar INT ; 

			IF(@FlagBorrador = 0 AND @ID NOT IN (SELECT IdAnticipo FROM ERP.AnticipoVentaCuentaCobrar))
				BEGIN
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
										AN.FechaEmision,
										1,
										CAST(0 AS BIT),
										AN.FechaEmision,
										AN.IdPeriodo
								FROM ERP.AnticipoVenta AN
								INNER JOIN ERP.Cliente CLI
								ON CLI.ID = AN.IdCliente
								INNER JOIN ERP.Entidad ENT
								ON ENT.ID = CLI.IdEntidad
								WHERE AN.ID = @ID

					SET @IdCuentaCobrar = SCOPE_IDENTITY()
				
					INSERT INTO ERP.AnticipoVentaCuentaCobrar (IdAnticipo,IdCuentaCobrar) VALUES(@ID,@IdCuentaCobrar)
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
							FROM ERP.CuentaCobrar CP
							INNER JOIN ERP.AnticipoVentaCuentaCobrar ANCP
							ON ANCP.IdCuentaCobrar = CP.ID
							INNER JOIN ERP.AnticipoVenta AN
							ON AN.ID = ANCP.IdAnticipo
							INNER JOIN ERP.Cliente CLI
							ON CLI.ID = AN.IdCliente
							INNER JOIN ERP.Entidad ENT
							ON ENT.ID = CLI.IdEntidad
							WHERE AN.ID = @ID
				END
				
				
END