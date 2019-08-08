
CREATE PROC [ERP].[Usp_Upd_CuentaCobrar_Comprobante]
@IdComprobante INT
AS
BEGIN 
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @FlagParsearEnteroDetraccion BIT = CAST((SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'VPTDA',GETDATE())) AS BIT);
	DECLARE @IdCuentaCobrar INT = 0
	DECLARE @FlagDetraccion BIT = (SELECT FlagDetraccion FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.Comprobante WHERE ID = @IdComprobante)
	
	UPDATE CC SET CC.IdEmpresa = C.IdEmpresa,
				 CC.IdEntidad = E.ID,
				 CC.Fecha = C.Fecha,
				 CC.IdTipoComprobante = C.IdTipoComprobante,
				 CC.Serie = C.Serie,
				 CC.Numero = Documento,
				 CC.Total = CASE WHEN @FlagDetraccion = 1 THEN
				 			C.Total - C.ImporteDetraccion
				 		ELSE
				 			C.Total
				 		END,
				 CC.TipoCambio = C.TipoCambio,
				 CC.IdMoneda = C.IdMoneda,
				 CC.IdDebeHaber = (CASE WHEN @IdTipoComprobante = 2 OR @IdTipoComprobante = 4 THEN
				 					CAST(1 AS INT)
				 				ELSE
				 					CAST(2 AS INT)
				 				END),
				 CC.FechaVencimiento = C.FechaVencimiento
	FROM ERP.CuentaCobrar CC
	INNER JOIN ERP.ComprobanteCuentaCobrar CCC ON CCC.IdCuentaCobrar = CC.ID
	INNER JOIN ERP.Comprobante C ON C.ID = CCC.IdComprobante
	INNER JOIN ERP.Cliente CLI ON CLI.ID = C.IdCliente
	INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
	WHERE C.ID = @IdComprobante AND CC.IdTipoComprobante = C.IdTipoComprobante

	IF @FlagDetraccion = 1 
	BEGIN
		DECLARE @COUNT_DETRACCION INT = ISNULL((SELECT COUNT(CCC.ID) FROM ERP.ComprobanteCuentaCobrar CCC
										INNER JOIN ERP.CuentaCobrar C ON C.ID = CCC.IdCuentaCobrar
										WHERE CCC.IdComprobante = @IdComprobante AND IdTipoComprobante = 166), 0)
		
		IF @COUNT_DETRACCION > 0
		BEGIN
			UPDATE CC SET CC.IdEmpresa = C.IdEmpresa,
				 CC.IdEntidad = E.ID,
				 CC.Fecha = C.Fecha,
				 CC.Serie = C.Serie,
				 CC.Numero = Documento,
				 CC.Total = CASE WHEN @FlagParsearEnteroDetraccion = 1 THEN
								CAST(ImporteDetraccion AS DECIMAL)
							ELSE
								ImporteDetraccion
							END,
				 CC.TipoCambio = C.TipoCambio,
				 CC.IdMoneda = C.IdMoneda,
				 CC.IdDebeHaber = CAST(1 AS INT),
				 CC.FechaVencimiento = C.FechaVencimiento
			FROM ERP.CuentaCobrar CC
			INNER JOIN ERP.ComprobanteCuentaCobrar CCC ON CCC.IdCuentaCobrar = CC.ID
			INNER JOIN ERP.Comprobante C ON C.ID = CCC.IdComprobante
			INNER JOIN ERP.Cliente CLI ON CLI.ID = C.IdCliente
			INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
			WHERE C.ID = @IdComprobante AND CC.IdTipoComprobante = 166
		END
		ELSE
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
										IdDebeHaber,
										FechaVencimiento,
										FechaRecepcion,
										FlagAnticipo
										)
			SELECT
				C.IdEmpresa,
				E.ID,
				Fecha,
				166, --DETRACCION
				Serie,
				Documento,
				CASE WHEN @FlagParsearEnteroDetraccion = 1 THEN
					CAST(ImporteDetraccion AS DECIMAL)
				ELSE
					ImporteDetraccion
				END,
				TipoCambio,
				IdMoneda,
				CAST(1 AS INT)											AS IdCuentaPagarOrigen,
				CAST(1 AS BIT)											AS Flag,
				CAST(0 AS BIT)											AS FlagCancelo,
				CAST(1 AS INT)											AS IdDebeHaber,
				FechaVencimiento,
				Fecha,
				CAST(0 AS BIT)											AS FlagAnticipo
			FROM ERP.Comprobante C
			INNER JOIN ERP.Cliente CLI ON CLI.ID = C.IdCliente
			INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
			WHERE C.ID = @IdComprobante

			SET @IdCuentaCobrar = SCOPE_IDENTITY()

			INSERT INTO ERP.ComprobanteCuentaCobrar (IdComprobante , IdCuentaCobrar) VALUES (@IdComprobante , @IdCuentaCobrar)
		END
	END
END
