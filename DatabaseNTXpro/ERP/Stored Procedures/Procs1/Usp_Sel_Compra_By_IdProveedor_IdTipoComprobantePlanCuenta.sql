CREATE PROC [ERP].[Usp_Sel_Compra_By_IdProveedor_IdTipoComprobantePlanCuenta]
@IdTipoComprobantePlanCuenta INT,
@IdProveedor INT
AS
BEGIN
	DECLARE @IdTipoComprobante INT, @IdMoneda INT, @IdTipoRelacion INT,@IdSistema INT, @IdPlanCuenta INT,@CuentaContable VARCHAR(250),@NombreTipoComprobantePlanCuenta VARCHAR(250);

	SET @IdTipoComprobante = (SELECT IdTipoComprobante FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdMoneda = (SELECT IdMoneda FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdTipoRelacion = (SELECT IdTipoRelacion FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdSistema = (SELECT IdSistema FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @IdPlanCuenta = (SELECT IdPlanCuenta FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)
	SET @CuentaContable = (SELECT CuentaContable FROM ERP.PlanCuenta WHERE ID = @IdPlanCuenta)
	SET @NombreTipoComprobantePlanCuenta = (SELECT Nombre FROM ERP.TipoComprobantePlanCuenta WHERE ID = @IdTipoComprobantePlanCuenta)

	SELECT	C.ID,
			C.Orden,
			C.IdTipoComprobante,
		    TC.Nombre NombreTipoComprobante,
			C.Serie,
			C.Numero,
			C.TipoCambio,
			C.Total AS SaldoInicialSoles,
			C.Total AS SaldoSoles,
			(C.Total/C.TipoCambio) AS SaldoInicialDolares,
			(C.Total/C.TipoCambio) AS SaldoDolares,
			@IdPlanCuenta IdPlanCuenta,
			@CuentaContable CuentaContable,
			@NombreTipoComprobantePlanCuenta NombreTipoComprobantePlanCuenta
	FROM ERP.Compra C
	INNER JOIN ERP.Proveedor P ON P.ID = C.IdProveedor
	INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = C.IdTipoComprobante
	WHERE IdProveedor = @IdProveedor AND C.IdTipoComprobante = @IdTipoComprobante
	AND C.IdMoneda = @IdMoneda AND P.idTipoRelacion = @IdTipoRelacion
END
