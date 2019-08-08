CREATE PROCEDURE [ERP].[Usp_Sel_TransformacionOrigenDetalle_By_IdTransformacion] --94
@IdTransformacion INT
AS
BEGIN
	SELECT
		TOD.ID,
		TOD.IdTransformacion,
		TOD.IdProducto,
		TOD.Lote,
		TOD.FlagAfecto,
		TOD.Cantidad,
		TOD.PrecioUnitario,
		TOD.SubTotal,
		TOD.IGV,
		TOD.Total,
		UPPER(P.CodigoReferencia) AS CodigoReferencia,
		CASE WHEN P.ID IS NULL THEN '' ELSE CONCAT(TOD.Lote, ' - ', P.Nombre) END AS NombreProducto,
		UM.Nombre AS NombreUnidadMedida
	FROM [ERP].[TransformacionOrigenDetalle] TOD
	LEFT JOIN ERP.Producto P ON TOD.IdProducto = P.ID
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
	WHERE TOD.IdTransformacion = @IdTransformacion
END
