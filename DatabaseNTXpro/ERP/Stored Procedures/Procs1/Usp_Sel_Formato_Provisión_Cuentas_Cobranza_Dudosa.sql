CREATE PROC [ERP].[Usp_Sel_Formato_Provisión_Cuentas_Cobranza_Dudosa]
@IdEmpresa int,
@IdAnio int,
@IdMes int 

AS
BEGIN
	
SELECT 
T2.CodigoSunat,
PC.CuentaContable,
ETD.NumeroDocumento,
E.Nombre,
AD.Documento Documento,
PC.Nombre NombreCuentaContable,

ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) ELSE 0 END), 0) AS Debe,
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) ELSE 0 END), 0) AS Haber,

ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) AS SALDO

FROM ERP.Asiento A
INNER JOIN ERP.AsientoDetalle AD ON AD.IdAsiento = A.ID
INNER JOIN ERP.PlanCuenta PC ON PC.ID = AD.IdPlanCuenta
INNER JOIN ERP.Entidad E ON E.ID = AD.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
INNER JOIN PLE.T2TipoDocumento T2 ON T2.ID = ETD.IdTipoDocumento
INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
WHERE A.Flag = 1 AND A.FlagBorrador = 0
AND PC.CuentaContable LIKE '16%'
AND P.IdAnio = @IdAnio
AND A.IdEmpresa = @IdEmpresa
AND P.IdMes= @IdMes
GROUP BY PC.CuentaContable,PC.Nombre, E.Nombre, T2.CodigoSunat, ETD.NumeroDocumento,AD.Documento
END