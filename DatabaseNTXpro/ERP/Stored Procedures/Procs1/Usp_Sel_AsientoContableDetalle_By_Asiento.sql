CREATE PROC [ERP].[Usp_Sel_AsientoContableDetalle_By_Asiento]-- 10
@IdAsiento INT
AS
BEGIN
	
	SELECT	AD.Orden, 
			PC.CuentaContable,
			AD.Nombre ,
			TC.Nombre NombreTipoComprobante,
			AD.Serie,
			AD.Documento,
			A.TipoCambio,
			CASE WHEN AD.IdDebeHaber = 1 THEN--DEBE
				AD.ImporteSoles
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS DebeSoles,
			CASE WHEN AD.IdDebeHaber = 2 THEN--HABER
				AD.ImporteSoles
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS HaberSoles,
			-------------------------DOLARES
			CASE WHEN AD.IdDebeHaber = 1 AND A.IdMoneda = 2 THEN--DEBE
				AD.ImporteDolares
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS DebeDolares,
			CASE WHEN AD.IdDebeHaber = 2 AND A.IdMoneda = 2 THEN--HABER
				AD.ImporteDolares
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS HaberDolares,
			A.Nombre NombreCabecera
	FROM ERP.AsientoDetalle AD
	LEFT JOIN ERP.Asiento A
		ON A.ID = AD.IdAsiento
	LEFT JOIN ERP.PlanCuenta PC
		ON PC.ID = AD.IdPlanCuenta
	LEFT JOIN PLE.T10TipoComprobante TC
		ON TC.ID = AD.IdTipoComprobante
	WHERE AD.IdAsiento = @IdAsiento
END
