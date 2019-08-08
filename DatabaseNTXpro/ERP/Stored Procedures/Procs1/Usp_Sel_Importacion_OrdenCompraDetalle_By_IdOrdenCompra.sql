CREATE PROC [ERP].[Usp_Sel_Importacion_OrdenCompraDetalle_By_IdOrdenCompra]
@IdOrdenCompra INT
AS
BEGIN
DECLARE @IdVale INT = (SELECT TOP 1 IR.IdImportacion 
								FROM ERP.ImportacionReferencia IR 
								INNER JOIN ERP.Importacion I ON I.ID = IR.IdImportacion
								WHERE IR.IdReferencia = @IdOrdenCompra AND IR.FlagInterno = 1 AND IR.IdReferenciaOrigen = 7 AND ISNULL(I.FlagBorrador, 0 ) = 0 AND I.IdImportacionEstado != 3)

	SELECT OCD.ID
	,OCD.IdOrdenCompra
      ,OCD.IdProducto
      ,OCD.Nombre
      ,OCD.FlagAfecto
       ,CASE WHEN @IdVale IS NULL THEN
		 OCD.Cantidad
		ELSE
			(SELECT [ERP].[ObtenerCantidadTotalDetalleOrdenCompra_Importacion](OCD.IdProducto, @IdOrdenCompra)) 
		END AS Cantidad
      ,OCD.PrecioUnitario
      ,OCD.SubTotal
      ,OCD.IGV
      ,OCD.Total
      ,OCD.IdOrdenCompra
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat CodigoSunatUnidadMedida
	  ,M.Nombre NombreMarca
	  ,PRO.IdEntidad
  FROM [ERP].[OrdenCompraDetalle] OCD
  INNER JOIN ERP.Producto P
		ON P.ID = OCD.IdProducto
  INNER JOIN ERP.OrdenCompra OC
	ON OC.ID = OCD.IdOrdenCompra
  LEFT JOIN ERP.Proveedor PRO
	ON PRO.ID = OC.IdProveedor
  LEFT JOIN PLE.T6UnidadMedida UM
  	ON UM.ID = P.IdUnidadMedida
  LEFT JOIN Maestro.Marca M
  	ON M.ID = P.IdMarca
  WHERE OCD.IdOrdenCompra = @IdOrdenCompra AND (@IdVale IS NULL OR (SELECT [ERP].[ObtenerCantidadTotalDetalleOrdenCompra_Importacion](OCD.IdProducto, @IdOrdenCompra)) != 0)

END
