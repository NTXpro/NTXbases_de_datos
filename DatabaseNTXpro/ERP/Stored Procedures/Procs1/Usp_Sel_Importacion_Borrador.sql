CREATE PROCEDURE [ERP].[Usp_Sel_Importacion_Borrador] --1
@IdEmpresa INT
AS
BEGIN
	SELECT 
	    I.ID,
		I.Fecha,
		TCD.VentaSunat,
		CONCAT(M.CodigoSunat, ' - ', UPPER(M.Nombre)) AS NombreMoneda,
	    CONCAT(P.Numero, ' - ', UPPER(P.Nombre)) AS NombreProyecto,
		AO.Nombre AS NombreAlmacen
	FROM [ERP].[Importacion] I
	LEFT JOIN ERP.Almacen AO ON I.IdAlmacen = AO.ID
	LEFT JOIN Maestro.Moneda M ON I.IdMoneda = M.ID
	LEFT JOIN ERP.Proyecto P ON I.IdProyecto = P.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(I.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
    WHERE 
	I.Flag = 1 AND
	I.FlagBorrador = 1 AND
	I.IdEmpresa = @IdEmpresa
END
