
CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoSinAplicar] --1,1
@IdProveedor INT ,
@IdEmpresa INT
AS
BEGIN

		SELECT	 AA.ID,
				 AA.ID,
				 AA.Fecha,
				 AA.Serie,
				 AA.Documento,
				 AA.Total,
				 AA.TipoCambio,
				 AA.IdMoneda,
				 AA.Moneda,
				 AA.IdTipoComprobante,
				 AA.TipoComprobante,
				 AA.IdProveedor,
				 AA.Proveedor,
				 AA.Saldo,
				 AA.Periodo
		FROM
		(SELECT	   CP.ID				ID,
				   CP.Fecha				Fecha,
				   CP.Serie				Serie,
				   CP.Numero			Documento,
				   CP.Total				Total,
				   (SELECT ERP.ObtenerTipoCambioVenta_By_Sistema_Fecha('SUNAT',CP.FechaRecepcion))		TipoCambio,
				   MO.ID				IdMoneda,
				   MO.CodigoSunat		Moneda,
				   TC.ID				IdTipoComprobante,
				   TC.Nombre			TipoComprobante,
				   PRO.ID				IdProveedor,
				   ENT.Nombre			Proveedor,
				   (SELECT(ERP.ObtenerTotalSaldoAplicacionCuentaPagar(CP.ID))) Saldo,
				   (A.Nombre + ' - '+ M.Nombre) AS Periodo
		FROM ERP.CuentaPagar CP
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CP.IdEntidad AND ENT.FlagBorrador = 0
		INNER JOIN ERP.Proveedor PRO
		ON PRO.IdEntidad = ENT.ID
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CP.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = CP.IdMoneda
		LEFT JOIN ERP.Periodo P
		ON P.ID = CP.IdPeriodo
		LEFT JOIN Maestro.Anio A
		ON A.ID = P.IdAnio
		LEFT JOIN Maestro.Mes M
		ON M.ID = P.IdMes
		WHERE CP.Flag = 1 AND PRO.ID = @IdProveedor AND CP.IdEmpresa = @IdEmpresa AND (TC.ID IN (183,8,200) OR (TC.ID = 178 AND CP.IdDebeHaber = 1))) AS AA WHERE ROUND(AA.Saldo,2) > 0

END