CREATE PROCEDURE [ERP].[Usp_Sel_TransformacionDestinoDetalle_By_IdTransformacion] --121
@IdTransformacion INT
AS
BEGIN
	SELECT
		TDD.ID,
		TDD.IdTransformacion,
		TDD.IdProducto,
		TDD.Fecha,
		CONVERT(VARCHAR(10), TDD.Fecha, 103) AS FechaStr,
		ISNULL(TDD.Lote, VD.NumeroLote) AS Lote,
		TDD.FlagAfecto,
		TDD.Cantidad,
		TDD.PrecioUnitario,
		TDD.SubTotal,
		TDD.IGV,
		TDD.Total,
		UPPER(P.CodigoReferencia) AS CodigoReferencia,
		P.Nombre AS NombreProducto,
		UM.Nombre AS NombreUnidadMedida
	FROM [ERP].[TransformacionDestinoDetalle] TDD
	LEFT JOIN ERP.Producto P ON TDD.IdProducto = P.ID
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
	---------------------------------------------------------------
	LEFT JOIN ERP.Transformacion T ON TDD.IdTransformacion = T.ID
	LEFT JOIN ERP.Vale V ON T.IdValeIngreso = V.ID
	LEFT JOIN ERP.ValeDetalle VD ON V.ID = VD.IdVale AND TDD.IdProducto = VD.IdProducto
	WHERE TDD.IdTransformacion = @IdTransformacion
END
