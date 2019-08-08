CREATE PROCEDURE [ERP].[Usp_Sel_TransformacionMermaDetalle_By_IdTransformacion]
@IdTransformacion INT
AS
BEGIN
	SELECT
		TMD.ID,
		TMD.IdTransformacion,
		TMD.IdProducto,
		TMD.Lote,
		TMD.FlagAfecto,
		TMD.Cantidad,
		TMD.PrecioUnitario,
		TMD.SubTotal,
		TMD.IGV,
		TMD.Total,
		UPPER(P.CodigoReferencia) AS CodigoReferencia,
		CASE WHEN P.ID IS NULL THEN '' ELSE CONCAT(TMD.Lote, ' - ', P.Nombre) END AS NombreProducto,
		UM.Nombre AS NombreUnidadMedida
	FROM [ERP].[TransformacionMermaDetalle] TMD
	LEFT JOIN ERP.Producto P ON TMD.IdProducto = P.ID
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
	WHERE TMD.IdTransformacion = @IdTransformacion
END
