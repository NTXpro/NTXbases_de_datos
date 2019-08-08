CREATE PROC [ERP].[Usp_Upd_SaldoInicial]
@ID INT,
@IdProveedor INT,
@IdPeriodo INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@Fecha DATETIME,
@FechaVencimiento DATETIME,
@FechaRecepcion DATETIME,
@Serie VARCHAR(4),
@Documento VARCHAR(20),
@Monto DECIMAL(14,6),
@TipoCambio DECIMAL(14,6),
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN

		UPDATE ERP.SaldoInicial
				SET IdProveedor = (CASE  @IdProveedor WHEN 0 THEN NULL ELSE @IdProveedor END),
				IdTipoComprobante=@IdTipoComprobante,
				IdMoneda = @IdMoneda,
				Fecha=@Fecha,
				FechaVencimiento =@FechaVencimiento ,
				FechaRecepcion = @FechaRecepcion,
				Serie = @Serie,
				Documento = @Documento,
				Monto = @Monto ,
				TipoCambio = @TipoCambio,
				FlagBorrador = @FlagBorrador,
				UsuarioModifico=@UsuarioModifico,
				FechaModificado = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @ID

		----------------=================== INSERTAMOS A LA TABLA CUENTA PAGAR =============--------------------
		DECLARE @IdEntidadProveedor INT = (SELECT IdEntidad FROM ERP.Proveedor WHERE ID = @IdProveedor)
		DECLARE @FlagSaldoActivo BIT = (SELECT Flag FROM ERP.SaldoInicial WHERE ID = @ID)
		DECLARE @IdCuentaPagar INT;


		DECLARE @Debe INT = 1
		DECLARE @Haber INT = 2

		IF @FlagBorrador = 0 AND @ID NOT IN (SELECT IdSaldoInicial FROM ERP.SaldoInicialCuentaPagar) AND @FlagSaldoActivo = 1
		BEGIN
			INSERT INTO ERP.CuentaPagar(	IdEmpresa,
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
											FechaRecepcion,
											IdDebeHaber,
											FlagAnticipo,
											IdPeriodo
											)
				SELECT
						SI.IdEmpresa										    AS IdEmpresa,
						@IdEntidadProveedor										AS IdEntidad,
						SI.Fecha												AS Fecha,
						SI.IdTipoComprobante									AS IdTipoComprobante,
						SI.Serie												AS Serie,	
						SI.Documento											AS Numero,
						SI.Monto												AS Total,
						SI.TipoCambio											AS TipoCambio,
						SI.IdMoneda												AS IdMoneda,
						CAST(2 AS INT)											AS IdCuentaPagarOrigen,--Saldos Iniciales
						CAST(1 AS BIT)											AS Flag,
						CAST(0 AS BIT)											AS FlagDetraccion,
						CAST(0 AS BIT)											AS FlagCancelo,
						SI.FechaVencimiento										AS FechaVencimiento,
						@FechaRecepcion											AS FechaRecepcion,
						CASE WHEN(@IdTipoComprobante IN (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Nombre LIKE '%' + 'CR%' OR ID = 183)) THEN @Debe ELSE  @Haber END	AS IdDebeHaber,
						CAST(0 AS BIT)											AS FlagAnticipo,
						@IdPeriodo												AS IdPeriodo
						FROM ERP.SaldoInicial SI WHERE ID = @ID

						SET @IdCuentaPagar = SCOPE_IDENTITY()

						INSERT INTO ERP.SaldoInicialCuentaPagar(IdSaldoInicial,IdCuentaPagar)VALUES(@ID,@IdCuentaPagar)
		END

		ELSE		UPDATE CP SET
					CP.IdEntidad = @IdEntidadProveedor,
					CP.Fecha = SI.Fecha,
					CP.IdTipoComprobante = SI.IdTipoComprobante ,
					CP.Serie = SI.Serie,
					CP.Numero = SI.Documento,
					CP.Total = SI.Monto,
					CP.TipoCambio = SI.TipoCambio,
					CP.IdMoneda = SI.IdMoneda,
					CP.FechaVencimiento = SI.FechaVencimiento,
					CP.FechaRecepcion = @FechaRecepcion,
					CP.IdPeriodo = @IdPeriodo,
					CP.IdDebeHaber = CASE WHEN(@IdTipoComprobante IN (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Nombre LIKE '%' + 'CR%' OR ID = 183)) THEN @Debe ELSE  @Haber END
					FROM ERP.CuentaPagar CP
					INNER JOIN ERP.SaldoInicialCuentaPagar CCP ON  CP.ID  = CCP.IdCuentaPagar 
					INNER JOIN ERP.SaldoInicial SI ON  CCP.IdSaldoInicial = SI.ID
					WHERE SI.ID = @ID

END
