CREATE PROC [ERP].[Usp_Sel_CuentaCobrar_By_ID_IdTipoComprobantePlanCuenta]
@Id INT,
@IdTipoComprobantePlanCuenta INT,
@TipoCambio DECIMAL(14,5)
AS
BEGIN

	DECLARE @IdTipoComprobante INT, @IdMonedaPlanCuenta INT, @IdTipoRelacion INT,@IdSistema INT, @IdPlanCuenta INT,@CuentaContable VARCHAR(250),@NombreTipoComprobantePlanCuenta VARCHAR(250);
	DECLARE @IdMonedaSoles INT = 1;
	DECLARE @IdMonedaDolares INT = 2; 

	SET @IdTipoComprobante = (SELECT IdTipoComprobante FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdMonedaPlanCuenta = (SELECT IdMoneda FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdTipoRelacion = (SELECT IdTipoRelacion FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdSistema = (SELECT IdSistema FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdPlanCuenta = (SELECT IdPlanCuenta FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @CuentaContable = (SELECT CuentaContable FROM ERP.PlanCuenta WHERE ID = @IdPlanCuenta)
	SET @NombreTipoComprobantePlanCuenta = (SELECT Nombre FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)

	
	SELECT	C.ID,
			c.IdEntidad,
			Serie,
			Numero,
			@TipoCambio TipoCambio,
			@IdPlanCuenta IdPlanCuenta,
				------------==================== SALDOS SOLES  ====================------------
			CASE WHEN C.IdMoneda = @IdMonedaSoles THEN 
				C.Total
			WHEN C.IdMoneda = @IdMonedaDolares THEN
				(C.Total * @TipoCambio)
			END  SaldoInicialSoles,
			-----------
			CASE WHEN C.IdMoneda = @IdMonedaSoles THEN 
				CAST((SELECT [ERP].[SaldoTotalCuentaCobrarDeSoles](C.ID)) AS DECIMAL(14,2))
			WHEN C.IdMoneda = @IdMonedaDolares THEN
				CAST((SELECT [ERP].[SaldoTotalCuentaCobrarDeDolares](C.ID) * @TipoCambio) AS DECIMAL(14,2))
			END  SaldoSoles,
			------------==================== SALDOS DOLARES  ====================------------
			CASE WHEN C.IdMoneda = @IdMonedaDolares THEN
				C.Total
			WHEN C.IdMoneda = @IdMonedaSoles THEN 
				CAST((C.Total / @TipoCambio)AS DECIMAL(14,2))
			END  SaldoInicialDolares,
			-----------
			CASE WHEN C.IdMoneda = @IdMonedaDolares THEN
				CAST((SELECT [ERP].[SaldoTotalCuentaCobrarDeDolares](C.ID)) AS DECIMAL(14,2))
			WHEN C.IdMoneda = @IdMonedaSoles THEN 
				CAST((SELECT [ERP].[SaldoTotalCuentaCobrarDeSoles](C.ID) / @TipoCambio) AS DECIMAL(14,2))
			END  SaldoDolares,
			IdTipoComprobante,
			TC.Nombre TipoComprobante,
			E.Nombre NombreEntidad,
			ETD.NumeroDocumento,
			C.IdDebeHaber
	FROM ERP.CuentaCobrar C
	INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = C.IdTipoComprobante
	INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
	WHERE C.ID = @Id
END