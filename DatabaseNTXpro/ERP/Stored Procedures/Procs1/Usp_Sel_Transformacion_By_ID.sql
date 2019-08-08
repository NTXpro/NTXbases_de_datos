CREATE PROCEDURE [ERP].[Usp_Sel_Transformacion_By_ID] --121
@ID INT
AS
BEGIN
	SELECT 
	    T.ID,
		T.IdEmpresa,
		T.IdAlmacenOrigen,
		T.IdAlmacenDestino,
		T.IdMoneda,
		T.IdProyecto,
		T.Observaciones,
		T.Fecha,
		T.IdValeIngreso,
		T.IdValeSalida,
		T.Documento,
		T.UsuarioRegistro,
		T.FechaRegistro,
		T.UsuarioModifico,
		T.FechaModificado,
		T.UsuarioActivo,
		T.FechaActivacion,
		T.UsuarioElimino,
		T.FechaEliminado,
		T.FlagBorrador,
		T.Flag,
		CONCAT(M.CodigoSunat, ' - ', UPPER(M.Nombre)) AS NombreMoneda,
		CONCAT(P.Numero, ' - ', UPPER(P.Nombre)) AS NombreProyecto,
		AO.Nombre AS NombreAlmacenOrigen,
		AD.Nombre AS NombreAlmacenDestino,
		VI.Documento AS DocumentoValeIngreso,
		CASE WHEN T.IdValeIngreso IS NULL THEN T.FechaIngreso ELSE VI.Fecha END AS FechaIngreso,
		VS.Documento AS DocumentoValeSalida,
		CASE WHEN T.IdValeSalida IS NULL THEN T.FechaSalida ELSE VS.Fecha END AS FechaSalida,
		TCD.VentaSunat AS TipoCambio,
		T.IdTransformacionEstado,
		TE.Abreviatura AS AbreviaturaEstado
	FROM [ERP].[Transformacion] T
	LEFT JOIN ERP.Almacen AO ON T.IdAlmacenOrigen = AO.ID
	LEFT JOIN ERP.Almacen AD ON T.IdAlmacenDestino = AD.ID
	LEFT JOIN Maestro.Moneda M ON T.IdMoneda = M.ID
	LEFT JOIN ERP.Proyecto P ON T.IdProyecto = P.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(T.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Vale VI ON T.IdValeIngreso = VI.ID
	LEFT JOIN ERP.Vale VS ON T.IdValeSalida = VS.ID
	LEFT JOIN Maestro.TransformacionEstado TE ON T.IdTransformacionEstado = TE.ID
    WHERE  T.ID = @ID
END
