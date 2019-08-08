
CREATE PROCEDURE [ERP].[Usp_Sel_Cuenta12_Clientes]

AS
BEGIN
	
SELECT 
T2.CodigoSunat,
PC.CuentaContable,
ETD.NumeroDocumento,
E.Nombre,

ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) ELSE 0 END), 0) AS Debe,
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) ELSE 0 END), 0) AS Haber,
(CASE 
WHEN 
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) >= 0 
THEN 			
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0)
ELSE 0
END) AS SALDO
FROM ERP.Asiento A
INNER JOIN ERP.AsientoDetalle AD ON AD.IdAsiento = A.ID
INNER JOIN ERP.PlanCuenta PC ON PC.ID = AD.IdPlanCuenta
INNER JOIN ERP.Entidad E ON E.ID = AD.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
INNER JOIN PLE.T2TipoDocumento T2 ON T2.ID = ETD.IdTipoDocumento
WHERE A.Flag = 1 AND A.FlagBorrador = 0
AND PC.CuentaContable LIKE '12%'
AND PC.IdAnio = 9
AND A.IdEmpresa = 4
AND A.IdPeriodo = 129
GROUP BY PC.CuentaContable, E.Nombre, T2.CodigoSunat, ETD.NumeroDocumento
END