CREATE PROCEDURE [ERP].[Usp_Sel_CentroCostoTotalizadoPorCuenta]
@IdProyecto INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME,
@IdEmpresa INT
AS
	SELECT PC.CuentaContable, 
			A.Nombre,
			CASE WHEN IdDebeHaber = 1
				THEN
					CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles
					ELSE AD.ImporteDolares END
			ELSE 0 END Debe,
			CASE WHEN IdDebeHaber = 2
				THEN
					CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles
					ELSE AD.ImporteDolares END
			ELSE 0 END Haber
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID	
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Moneda MO ON A.IdMoneda = MO.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Entidad E ON E.ID = AD.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
	LEFT JOIN PLE.T2TipoDocumento T2 ON ETD.IdTipoDocumento = T2.ID
	LEFT JOIN PLE.T10TipoComprobante T10 ON T10.ID = AD.IdTipoComprobante
	INNER JOIN ERP.Proyecto PR ON PR.ID = AD.IdProyecto
	WHERE A.Flag = 1
	AND A.FlagBorrador = 0
	AND A.IdEmpresa = @IdEmpresa
	AND (@IdProyecto = 0 OR P.ID = @IdProyecto)
	ORDER BY A.Fecha, A.Orden ASC