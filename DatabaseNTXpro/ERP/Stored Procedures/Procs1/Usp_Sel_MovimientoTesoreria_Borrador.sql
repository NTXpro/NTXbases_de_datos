CREATE PROC [ERP].[Usp_Sel_MovimientoTesoreria_Borrador]
@IdEmpresa INT
AS
BEGIN

	SELECT	MT.ID,
		    MT.Orden,
		    ETD.NumeroDocumento,
		    MT.Nombre NombreMovimiento,
            CTM.Nombre NombreCategoriaMovimiento,
		    MT.Fecha,
		    MT.IdTipoMovimiento,
		    CASE WHEN MT.IdTipoMovimiento = 1 THEN --INGRESO
			    MT.Total
		    ELSE
			    CAST(0 AS DECIMAL(14,5))
		    END AS Ingreso,
		    CASE WHEN MT.IdTipoMovimiento = 2 THEN --SALIDA
			    MT.Total
		    ELSE
			    CAST(0 AS DECIMAL(14,5))
		    END AS Egreso
    FROM ERP.MovimientoTesoreria MT
    LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
    LEFT JOIN ERP.Entidad E ON E.ID = MT.IdEntidad
    LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
    WHERE MT.FlagBorrador = 1
    AND MT.IdEmpresa = @IdEmpresa

END