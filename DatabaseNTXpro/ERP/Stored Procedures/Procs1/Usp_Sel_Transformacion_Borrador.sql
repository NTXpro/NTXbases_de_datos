CREATE PROCEDURE [ERP].[Usp_Sel_Transformacion_Borrador] --1
@IdEmpresa INT
AS
BEGIN
	SELECT 
	    T.ID,
		T.Fecha,
		TCD.VentaSunat,
		CONCAT(M.CodigoSunat, ' - ', UPPER(M.Nombre)) AS NombreMoneda,
	    CONCAT(P.Numero, ' - ', UPPER(P.Nombre)) AS NombreProyecto,
		AO.Nombre AS NombreAlmacenOrigen,
		AD.Nombre AS NombreAlmacenDestino
	FROM [ERP].[Transformacion] T
	LEFT JOIN ERP.Almacen AO ON T.IdAlmacenOrigen = AO.ID
	LEFT JOIN ERP.Almacen AD ON T.IdAlmacenDestino = AD.ID
	LEFT JOIN Maestro.Moneda M ON T.IdMoneda = M.ID
	LEFT JOIN ERP.Proyecto P ON T.IdProyecto = P.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(T.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
    WHERE 
	T.Flag = 1 AND
	T.FlagBorrador = 1 AND
	T.IdEmpresa = @IdEmpresa
END
