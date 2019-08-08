CREATE PROC [ERP].[Usp_Sel_Formato_CajayBancos]
@IdEmpresa int,
@IdAnio int,
@IdMes int 

AS
BEGIN
	
SELECT 
PC.CuentaContable, PC.Nombre NombreCuentaContable, AD.Nombre NombreAsiento,
IIF(C.BancoCodigoSunat IS NULL, 99, C.BancoCodigoSunat) EntidadFinanciera, 
C.Nombre NumeroCuenta, C.MonedaCodigoSunat,
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) ELSE 0 END), 0) AS Debe,
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) ELSE 0 END), 0) AS Haber,


ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) AS SALDO 

 
FROM ERP.Asiento A
    INNER JOIN ERP.AsientoDetalle AD ON AD.IdAsiento = A.ID
    INNER JOIN ERP.PlanCuenta PC ON PC.ID = AD.IdPlanCuenta
	
    INNER JOIN
(
   SELECT E.ID, 
          E.Nombre, 
          ETD.IdTipoDocumento, 
          ETD.NumeroDocumento
   FROM ERP.Entidad E
        INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
   WHERE E.Flag = 1
         AND E.FlagBorrador = 0
) ETD ON ETD.ID = AD.IdEntidad
    INNER JOIN PLE.T2TipoDocumento T2 ON T2.ID = ETD.IdTipoDocumento
	INNER JOIN ERP.Periodo PP ON A.IdPeriodo = PP.ID
    INNER JOIN ERP.MovimientoTesoreria MT ON MT.IdAsiento = A.ID
    INNER JOIN
(
   SELECT C.ID, 
          C.Nombre, 
          C.IdEmpresa, 
          E.Nombre NombreEntidad, 
          M.Nombre NombreMoneda, 
          M.CodigoSunat MonedaCodigoSunat, 
          M.Simbolo, 
          T3.CodigoSunat BancoCodigoSunat
   FROM ERP.Cuenta C
        INNER JOIN ERP.Entidad E ON E.Id = C.IdEntidad
	
        INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
        LEFT JOIN PLE.T3Banco T3 ON T3.IdEntidad = E.ID
   WHERE C.Flag = 1
         AND C.FlagBorrador = 0
) C ON C.ID = MT.IdCuenta
WHERE A.Flag = 1
     AND A.FlagBorrador = 0
     AND PC.CuentaContable LIKE '10%'
     AND PP.IdAnio = @IdAnio
     AND A.IdEmpresa = @IdEmpresa
     AND PP.IdMes = @IdMes
GROUP BY PC.CuentaContable, PC.Nombre, AD.Nombre,
C.BancoCodigoSunat, C.Nombre, C.MonedaCodigoSunat

end