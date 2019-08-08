

CREATE PROC [ERP].[Usp_Sel_Vale_Importar] --28,1,1
@IdProveedor INT,
@IdEmpresa INT,
@IdTipoMovimiento INT
AS
BEGIN
		DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.Proveedor WHERE ID = @IdProveedor)

		SELECT VA.ID,
			   VA.Fecha,
			   ENT.Nombre Entidad,
			   ETD.NumeroDocumento,
			   VA.Total,
			   VA.Serie,
			   VA.Documento,
			   MO.CodigoSunat Moneda,
			   VA.Total,
			   TM.Abreviatura,
			   VA.IdTipoComprobante,
			   TC.Nombre		NombreComprobante
		FROM ERP.Vale VA
		INNER JOIN Maestro.Moneda MO ON MO.ID = VA.IdMoneda
		INNER JOIN ERP.Entidad ENT ON ENT.ID = VA.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = ENT.ID
		INNER JOIN Maestro.TipoMovimiento TM ON TM.ID = VA.IdTipoMovimiento
		INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = VA.IdTipoComprobante
		WHERE VA.IdEntidad = @IdEntidad AND VA.IdEmpresa = @IdEmpresa AND VA.IdTipoMovimiento = @IdTipoMovimiento
		AND VA.FlagBorrador = 0 AND VA.Flag = 1 AND VA.IdValeEstado = 1 AND VA.IdConcepto = 2
END