CREATE PROC ERP.Usp_Ins_CuentaCobrar_Comprobante
@IdComprobante INT
AS
BEGIN 
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @FlagParsearEnteroDetraccion BIT = CAST((SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'VPTDA',GETDATE())) AS BIT);
	DECLARE @IdCuentaCobrar INT = 0
	DECLARE @FlagDetraccion BIT = (SELECT FlagDetraccion FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.Comprobante WHERE ID = @IdComprobante)
	
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
		IdTipoComprobante,
		Serie,
		Documento,
		CASE WHEN @FlagDetraccion = 1 THEN
			Total - ImporteDetraccion
		ELSE
			Total
		END Total,
		TipoCambio,
		IdMoneda,
		CAST(1 AS INT)											AS IdCuentaPagarOrigen,
		CAST(1 AS BIT)											AS Flag,
		CAST(0 AS BIT)											AS FlagCancelo,
		(CASE WHEN @IdTipoComprobante = 2 OR @IdTipoComprobante = 4 THEN
			CAST(1 AS INT)
		ELSE
			CAST(2 AS INT)
		END) AS IdDebeHaber,
		FechaVencimiento,
		Fecha,
		CAST(0 AS BIT)											AS FlagAnticipo
	FROM ERP.Comprobante C
	INNER JOIN ERP.Cliente CLI ON CLI.ID = C.IdCliente
	INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
	WHERE C.ID = @IdComprobante
		
	SET @IdCuentaCobrar = SCOPE_IDENTITY()

	INSERT INTO ERP.ComprobanteCuentaCobrar (IdComprobante , IdCuentaCobrar) VALUES (@IdComprobante , @IdCuentaCobrar)

	IF @FlagDetraccion = 1 
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
