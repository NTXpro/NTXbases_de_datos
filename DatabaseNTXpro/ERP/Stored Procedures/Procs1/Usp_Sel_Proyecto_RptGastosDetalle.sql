CREATE PROCEDURE ERP.Usp_Sel_Proyecto_RptGastosDetalle
@IdProyecto INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME
AS
	SELECT PC.CuentaContable,
			PC.Nombre NombrePlanCuenta,		
			RIGHT('0000000' + CAST(A.Orden AS VARCHAR(255)), 7) Asiento,
			AD.Fecha FechaAsientoDet,
			AD.Nombre NombreAsientoDet,
			AD.IdTipoComprobante,
			AD.Serie,
			AD.Documento,
			CASE 
				WHEN P.IdMoneda = 1 AND AD.IdDebeHaber = 1 THEN AD.ImporteSoles
				WHEN P.IdMoneda = 2 AND AD.IdDebeHaber = 1 THEN AD.ImporteDolares
				WHEN P.IdMoneda = 1 AND AD.IdDebeHaber = 2 THEN AD.ImporteSoles * -1
				WHEN P.IdMoneda = 2 AND AD.IdDebeHaber = 2 THEN AD.ImporteDolares * -1
				ELSE 0 END Importe,
			AD.IdDebeHaber			
	FROM ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Proyecto P ON P.ID = AD.IdProyecto	
	WHERE A.Flag = 1
	AND A.FlagBorrador = 0	
	AND (AD.ImporteDolares > 0 OR AD.ImporteSoles > 0)	
	AND PC.CuentaContable LIKE '9%'
	AND A.IdOrigen != 5
	AND (@FechaDesde IS NULL OR @FechaDesde <= A.Fecha)
	AND (@FechaHasta IS NULL OR @FechaHasta >= A.Fecha)	
	AND @IdProyecto = IdProyecto