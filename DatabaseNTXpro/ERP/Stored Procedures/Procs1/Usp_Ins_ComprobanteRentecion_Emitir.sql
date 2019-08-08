
CREATE PROCEDURE ERP.Usp_Ins_ComprobanteRentecion_Emitir
@IdComprobanteRetencion INT,
@UsuarioRegistro VARCHAR(255)
AS
	DECLARE @IdCuentaCobrarRetencion INT
	DECLARE @IdAplicacionAnticipoCobrar INT
	DECLARE @IdAsiento INT
	DECLARE @Soles INT = 1
	DECLARE @TipoComprobanteRetencion INT = 21
	DECLARE @Debe INT = 1
	DECLARE @Haber INT = 2	

	INSERT INTO ERP.CuentaCobrar
		(
			IdEmpresa,
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
			FlagAnticipo,
			FechaRecepcion
		)			
	SELECT CR.IdEmpresa, 
			C.IdEntidad, 
			CR.FechaEmision, 
			@TipoComprobanteRetencion, --IdTipoComprobante Retencion
			CR.Serie,
			CR.Documento,			
			CR.ImporteRetenido,
			CR.TipoCambio,
			1, -- Las Retenciones es a Soles
			4, --COMPROBANTE RETENCION ORIGEN
			1, --Activo
			1, --Cancelado
			@Haber, --HABER
			CR.FechaEmision,
			1, --Vamos a crear un anticipo
			NULL
	FROM ERP.ComprobanteRetencion CR
	INNER JOIN ERP.Cliente C ON CR.IdCliente = C.ID
	WHERE CR.ID = @IdComprobanteRetencion

	SET @IdCuentaCobrarRetencion = SCOPE_IDENTITY()
	
	INSERT INTO ERP.AplicacionAnticipoCobrar
				(
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
	SELECT @IdCuentaCobrarRetencion,
			IdCliente,
			1, -- SOLES
			@TipoComprobanteRetencion, 
			Documento,
			Serie,
			FechaEmision,
			TipoCambio,
			ImporteRetenido,
			FechaEmision,
			@UsuarioRegistro,
			IdEmpresa,
			1,
			FechaEmision
	FROM ERP.ComprobanteRetencion
	WHERE ID = @IdComprobanteRetencion

	SET @IdAplicacionAnticipoCobrar = SCOPE_IDENTITY()
	
	INSERT INTO ERP.AplicacionAnticipoCobrarDetalle
				(
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
	SELECT @IdAplicacionAnticipoCobrar, 
			CCC.IdCuentaCobrar,
			c.IdTipoComprobante,
			C.IdMoneda,
			C.Documento,
			C.Serie,
			C.Fecha,
			C.Total,
			CRD.MontoRetenidoSoles,
			@Debe --DEBE
	FROM ERP.ComprobanteRetencionDetalle CRD
	INNER JOIN ERP.Comprobante C ON C.ID = CRD.IdComprobante
	INNER JOIN ERP.ComprobanteCuentaCobrar CCC ON C.ID = CCC.IdComprobante		
	WHERE IdComprobanteRetencion = @IdComprobanteRetencion

	INSERT INTO ERP.AplicacionAnticipoCobrarDetalle
				(
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
	SELECT @IdAplicacionAnticipoCobrar, 
			SICC.IdCuentaCobrar,
			SIC.IdTipoComprobante,
			SIC.IdMoneda, 
			SIC.Documento,
			SIC.Serie,
			SIC.Fecha,
			SIC.Monto,
			CRD.MontoRetenidoSoles,
			@Debe --DEBE
	FROM ERP.ComprobanteRetencionDetalle CRD
	INNER JOIN ERP.SaldoInicialCobrar SIC ON SIC.ID = CRD.IdSaldoInicial
	INNER JOIN ERP.SaldoInicialCuentaCobrar SICC ON SIC.ID = SICC.IdSaldoInicialCobrar
	WHERE IdComprobanteRetencion = @IdComprobanteRetencion	

	EXEC ERP.Usp_Ins_AsientoContable_CuentaCobrar @IdAsiento OUT, @IdAplicacionAnticipoCobrar,8 /*CUENTAS POR COBRAR(ORIGEN)*/,2 /*VENTAS (SISTEMA)*/

	UPDATE ERP.AplicacionAnticipoCobrar 
	SET IdAsiento = @IdAsiento 
	WHERE ID = @IdAplicacionAnticipoCobrar

	UPDATE ERP.ComprobanteRetencion
	SET FlagEmitido = 1,
		IdCuentaCobrar = @IdCuentaCobrarRetencion
	WHERE ID = @IdComprobanteRetencion
