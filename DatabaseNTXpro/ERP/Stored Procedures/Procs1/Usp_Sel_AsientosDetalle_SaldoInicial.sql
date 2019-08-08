/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROC ERP.Usp_Sel_AsientosDetalle_SaldoInicial
@IdEmpresa INT
AS
BEGIN
SELECT AD.ID
	  ,A.ID
	  ,A.IdEmpresa
	  ,PC.CuentaContable
      ,AD.IdPlanCuenta
      ,AD.Fecha
	  ,P.ID IdProveedor
	  ,C.ID IdCliente
	  ,A.IdMoneda
	  ,A.TipoCambio
      ,AD.ImporteSoles
      ,AD.ImporteDolares
      ,AD.IdEntidad
      ,AD.IdTipoComprobante
      ,AD.Serie
      ,AD.Documento
  FROM [ERP].[AsientoDetalle] AD
  INNER JOIN ERP.Asiento A ON A.ID = AD.IdAsiento
  INNER JOIN ERP.PlanCuenta PC ON PC.ID = AD.IdPlanCuenta
  LEFT JOIN ERP.Cliente C ON C.IdEntidad = AD.IdEntidad AND C.FlagBorrador = 0 AND C.IdEmpresa = A.IdEmpresa
  LEFT JOIN ERP.Proveedor P ON P.IdEntidad = AD.IdEntidad AND P.FlagBorrador = 0 AND P.IdEmpresa = A.IdEmpresa
  WHERE  A.IdOrigen = 2 and A.flag = 1 and A.flagborrador = 0
  AND A.IdEmpresa = @IdEmpresa
END