CREATE PROC [ERP].[Usp_Sel_RequerimientoDetalleImportadoParcial_By_IdRequerimiento] --2
@IdRequerimiento INT
AS
BEGIN

DECLARE @IdOrdenCompra INT = (SELECT TOP 1 OCR.IdOrdenCompra 
								FROM ERP.OrdenCompraReferencia OCR 
								INNER JOIN ERP.OrdenCompra OC ON OC.ID = OCR.IdOrdenCompra
								WHERE OCR.IdReferencia = @IdRequerimiento AND OCR.FlagInterno = 1 AND OCR.IdReferenciaOrigen = 6 AND OC.FlagBorrador = 0 AND OC.IdOrdenCompraEstado != 2)

SELECT RD.ID
      ,RD.IdRequerimiento
      ,RD.IdProducto
      ,RD.Nombre
      ,CASE WHEN @IdOrdenCompra IS NULL THEN
		 RD.Cantidad
	  ELSE
	  (SELECT ERP.ObtenerCantidadTotalDetalleRequerimiento(RD.IdProducto, @IdRequerimiento)) 
	  END AS Cantidad
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat  CodigoSunatUnidadMedida
	  ,R.IdEntidad
  FROM ERP.RequerimientoDetalle RD
  LEFT JOIN ERP.Requerimiento R ON R.ID = RD.IdRequerimiento
  LEFT JOIN ERP.Producto P ON P.ID = RD.IdProducto
  LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
  WHERE RD.IdRequerimiento = @IdRequerimiento AND (@IdOrdenCompra IS NULL OR (SELECT ERP.ObtenerCantidadTotalDetalleRequerimiento(RD.IdProducto, @IdRequerimiento)) != 0)
END
