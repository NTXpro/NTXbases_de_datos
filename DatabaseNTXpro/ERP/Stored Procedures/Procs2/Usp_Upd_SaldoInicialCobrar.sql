CREATE PROC [ERP].[Usp_Upd_SaldoInicialCobrar]
@ID INT,
@IdCliente INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@Fecha DATETIME,
@FechaVencimiento DATETIME,
@Serie VARCHAR(4),
@Documento VARCHAR(8),
@Monto DECIMAL(14,6),
@TipoCambio DECIMAL(14,6),
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN

		UPDATE ERP.SaldoInicialCobrar
				SET IdCliente = (CASE  @IdCliente WHEN 0 THEN NULL ELSE @IdCliente END),
				IdTipoComprobante=@IdTipoComprobante,
				IdMoneda = @IdMoneda,
				Fecha=@Fecha,
				FechaVencimiento =@FechaVencimiento ,
				Serie = @Serie,
				Documento = @Documento,
				Monto = @Monto ,
				TipoCambio = @TipoCambio,
				FlagBorrador = @FlagBorrador,
				UsuarioModifico=@UsuarioModifico,
				FechaModificado = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @ID

		----------------=================== INSERTAMOS A LA TABLA CUENTA COBRAR =============--------------------
		DECLARE @IdEntidadCliente INT = (SELECT IdEntidad FROM ERP.Cliente WHERE ID = @IdCliente)
		DECLARE @FlagSaldoActivo BIT = (SELECT Flag FROM ERP.SaldoInicialCobrar WHERE ID = @ID)
		DECLARE @IdCuentaCobrar INT

		DECLARE @Debe INT = 1
		DECLARE @Haber INT = 2

		IF @FlagBorrador = 0 AND @ID NOT IN (SELECT IdSaldoInicialCobrar FROM ERP.SaldoInicialCuentaCobrar) AND @FlagSaldoActivo = 1
		BEGIN
			INSERT INTO ERP.CuentaCobrar(	IdEmpresa,
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
											FlagAnticipo
											)
				SELECT
						SI.IdEmpresa										    AS IdEmpresa,
						@IdEntidadCliente										AS IdEntidad,
						SI.Fecha												AS Fecha,
						SI.IdTipoComprobante									AS IdTipoComprobante,
						SI.Serie												AS Serie,	
						SI.Documento											AS Numero,
						SI.Monto												AS Total,
						SI.TipoCambio											AS TipoCambio,
						SI.IdMoneda												AS IdMoneda,
						CAST(2 AS INT)											AS IdCuentaPagarOrigen,--Saldos Iniciales
						CAST(1 AS BIT)											AS Flag,
						CAST(0 AS BIT)											AS FlagCancelo,
						SI.FechaVencimiento										AS FechaVencimiento,
						CASE WHEN(@IdTipoComprobante IN (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Nombre LIKE '%' + 'CR%' OR ID = 183)) THEN @Haber ELSE @Debe	END	AS IdDebeHaber,
						CAST(0 AS BIT)											AS FlagAnticipo

						FROM ERP.SaldoInicialCobrar SI WHERE ID = @ID

						SET @IdCuentaCobrar = SCOPE_IDENTITY()

						INSERT INTO ERP.SaldoInicialCuentaCobrar(IdSaldoInicialCobrar,IdCuentaCobrar)VALUES(@ID,@IdCuentaCobrar)
		END

		ELSE		UPDATE CP SET
					CP.IdEntidad = @IdEntidadCliente,
					CP.Fecha = SI.Fecha,
					CP.IdTipoComprobante = SI.IdTipoComprobante ,
					CP.Serie = SI.Serie,
					CP.Numero = SI.Documento,
					CP.Total = SI.Monto,
					CP.TipoCambio = SI.TipoCambio,
					CP.IdMoneda = SI.IdMoneda,
					CP.FechaVencimiento = SI.FechaVencimiento,
					CP.IdDebeHaber = CASE WHEN(@IdTipoComprobante IN (SELECT ID FROM [PLE].[T10TipoComprobante] WHERE Nombre LIKE '%' + 'CR%' OR ID = 183)) THEN @Haber ELSE @Debe END
					FROM ERP.CuentaCobrar CP
					INNER JOIN ERP.SaldoInicialCuentaCobrar CCP ON  CP.ID  = CCP.IdCuentaCobrar 
					INNER JOIN ERP.SaldoInicialCobrar SI ON  CCP.IdSaldoInicialCobrar = SI.ID
					WHERE SI.ID = @ID
END
