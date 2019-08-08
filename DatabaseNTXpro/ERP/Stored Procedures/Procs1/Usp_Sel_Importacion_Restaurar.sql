CREATE PROCEDURE [ERP].[Usp_Sel_Importacion_Restaurar]
@IdEmpresa INT
AS
BEGIN
	SELECT 
	    I.ID,
		I.Documento,
		I.Fecha,
		TCD.VentaSunat,
		CONCAT(M.CodigoSunat, ' - ', UPPER(M.Nombre)) AS NombreMoneda,
	    CONCAT(P.Numero, ' - ', UPPER(P.Nombre)) AS NombreProyecto,
		AO.Nombre AS NombreAlmacen
	FROM [ERP].[Importacion] I
	INNER JOIN ERP.Almacen AO ON I.IdAlmacen = AO.ID
	INNER JOIN Maestro.Moneda M ON I.IdMoneda = M.ID
	LEFT JOIN ERP.Proyecto P ON I.IdProyecto = P.ID
	INNER JOIN ERP.TipoCambioDiario TCD ON CAST(I.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
    WHERE 
    I.Flag = 0 AND
	I.IdEmpresa = @IdEmpresa
END
