CREATE PROCEDURE [ERP].[Usp_Sel_Importacion_By_ID] --121
@ID INT
AS
BEGIN
	SELECT 
	    I.ID,
		I.IdEmpresa,
		I.IdAlmacen,
		I.IdMoneda,
		I.IdProyecto,
		I.Observacion,
		I.Fecha,
		I.IdVale,
		I.Documento,
		I.UsuarioRegistro,
		I.FechaRegistro,
		I.UsuarioModifico,
		I.FechaModificado,
		I.UsuarioActivo,
		I.FechaActivacion,
		I.UsuarioElimino,
		I.FechaEliminado,
		I.FlagBorrador,
		I.Flag,
		CONCAT(M.CodigoSunat, ' - ', UPPER(M.Nombre)) AS NombreMoneda,
		CONCAT(P.Numero, ' - ', UPPER(P.Nombre)) AS NombreProyecto,
		AO.Nombre AS NombreAlmacen,
		V.Documento AS DocumentoVale,
		CASE WHEN I.IdVale IS NULL THEN I.FechaVale ELSE V.Fecha END AS FechaVale,
		TCD.VentaSunat AS TipoCambio,
		I.IdImportacionEstado,
		ISNULL(IE.Abreviatura, '') AS AbreviaturaEstado
	FROM [ERP].[Importacion] I
	LEFT JOIN ERP.Almacen AO ON I.IdAlmacen = AO.ID
	LEFT JOIN Maestro.Moneda M ON I.IdMoneda = M.ID
	LEFT JOIN ERP.Proyecto P ON I.IdProyecto = P.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(I.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Vale V ON I.IdVale = V.ID
	LEFT JOIN Maestro.ImportacionEstado IE ON I.IdImportacionEstado = IE.ID
    WHERE  I.ID = @ID
END
