CREATE PROCEDURE ERP.Usp_Sel_Proyecto_RptPresupuesto
@IdProyecto INT,
@IdCliente INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME
AS
	SELECT P.ID IdProyecto,
			P.IdMoneda,
			P.Numero,
			P.Nombre NombreProyecto,
			E.Nombre NombreCliente,
			ISNULL(P.PresupuestoVenta, 0) PresupuestoVenta,
			ISNULL(P.PresupuestoCompra, 0) PresupuestoCompra,
			ISNULL(PTV.TotalProyectoVenta, 0) TotalProyectoVenta,
			ISNULL(PTC.TotalProyectoCompra, 0) TotalProyectoCompra,
			ISNULL(PTA.TotalProyectoGasto, 0) TotalProyectoGasto
	FROM ERP.Proyecto P
	LEFT JOIN ERP.Cliente C ON P.IdCliente = C.ID
	LEFT JOIN ERP.Entidad E ON C.IdEntidad = E.ID
	LEFT JOIN (
		SELECT IdProyecto, SUM(CASE 
								WHEN P.IdMoneda = 1 AND C.IdMoneda = 1 THEN C.Total
								WHEN P.IdMoneda = 2 AND C.IdMoneda = 2 THEN C.Total
								WHEN P.IdMoneda = 2 AND C.IdMoneda = 1 THEN C.Total / C.TipoCambio
								WHEN P.IdMoneda = 1 AND C.IdMoneda = 2 THEN C.Total * C.TipoCambio
								ELSE 0 END) TotalProyectoVenta
		FROM ERP.Comprobante C
		INNER JOIN ERP.Proyecto P ON P.ID = C.IdProyecto
		WHERE C.IdComprobanteEstado IN (1, 2)
		AND C.IdTipoComprobante IN (2, 3, 4, 13)
		AND C.Flag = 1
		AND C.FlagBorrador = 0
		AND C.IdProyecto IS NOT NULL
		AND (@FechaDesde IS NULL OR @FechaDesde <= C.Fecha)
		AND (@FechaHasta IS NULL OR @FechaHasta >= C.Fecha)
		GROUP BY IdProyecto
	) PTV ON PTV.IdProyecto = P.ID
	LEFT JOIN (
		SELECT SUM(CASE 
				WHEN P.IdMoneda = 1 AND C.IdMoneda = 1 THEN CD.Importe
				WHEN P.IdMoneda = 2 AND C.IdMoneda = 2 THEN CD.Importe
				WHEN P.IdMoneda = 2 AND C.IdMoneda = 1 THEN CD.Importe / C.TipoCambio
				WHEN P.IdMoneda = 1 AND C.IdMoneda = 2 THEN CD.Importe * C.TipoCambio
				ELSE 0 END) TotalProyectoCompra, IdProyecto
		FROM ERP.Compra C
		INNER JOIN ERP.CompraDetalle CD ON C.ID = CD.IdCompra
		INNER JOIN ERP.Proyecto P ON P.ID = CD.IdProyecto
		WHERE C.Flag = 1
		AND C.FlagBorrador = 0
		AND CD.IdProyecto IS NOT NULL
		AND (@FechaDesde IS NULL OR @FechaDesde <= C.FechaEmision)
		AND (@FechaHasta IS NULL OR @FechaHasta >= C.FechaEmision)
		GROUP BY CD.IdProyecto
	) PTC ON PTC.IdProyecto = P.ID
	LEFT JOIN (
		SELECT SUM(CASE 
					WHEN P.IdMoneda = 1 AND AD.IdDebeHaber = 1 THEN AD.ImporteSoles
					WHEN P.IdMoneda = 2 AND AD.IdDebeHaber = 1 THEN AD.ImporteDolares
					WHEN P.IdMoneda = 1 AND AD.IdDebeHaber = 2 THEN AD.ImporteSoles * -1
					WHEN P.IdMoneda = 2 AND AD.IdDebeHaber = 2 THEN AD.ImporteDolares * -1
					ELSE 0 END) TotalProyectoGasto, IdProyecto
			FROM ERP.Asiento A
			INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
			INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
			INNER JOIN ERP.Proyecto P ON P.ID = AD.IdProyecto
			WHERE A.Flag = 1
			AND A.FlagBorrador = 0
			AND AD.IdProyecto IS NOT NULL
			AND PC.CuentaContable LIKE '9%'
			AND A.IdOrigen != 5
			AND (@FechaDesde IS NULL OR @FechaDesde <= A.Fecha)
			AND (@FechaHasta IS NULL OR @FechaHasta >= A.Fecha)
			GROUP BY AD.IdProyecto		
	) PTA ON PTA.IdProyecto = P.ID
	WHERE P.Flag = 1
	AND P.FlagBorrador = 0
	AND (@IdProyecto = 0 OR P.ID = @IdProyecto)
	AND (@IdCliente = 0 OR P.IdCliente = @IdCliente)