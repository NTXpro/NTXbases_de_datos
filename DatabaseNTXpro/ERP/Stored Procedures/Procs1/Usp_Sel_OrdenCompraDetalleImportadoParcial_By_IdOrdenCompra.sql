CREATE PROC [ERP].[Usp_Sel_OrdenCompraDetalleImportadoParcial_By_IdOrdenCompra]
@IdOrdenCompra INT
AS
BEGIN


DECLARE @IdVale INT = (SELECT TOP 1 VR.IdVale 
								FROM ERP.ValeReferencia VR 
								INNER JOIN ERP.Vale V ON V.ID = VR.IdVale
								WHERE VR.IdReferencia = @IdOrdenCompra AND VR.FlagInterno = 1 AND VR.IdReferenciaOrigen = 7 AND V.FlagBorrador = 0 AND V.IdValeEstado != 2)


DECLARE @IdImportacion INT = (SELECT TOP 1 VR.IdImportacion 
								FROM ERP.ImportacionReferencia VR 
								INNER JOIN ERP.Importacion V ON V.ID = VR.IdImportacion
								WHERE VR.IdReferencia = @IdOrdenCompra AND VR.FlagInterno = 1 AND VR.IdReferenciaOrigen = 7 AND V.FlagBorrador = 0 AND V.IdImportacionEstado != 3)


	SELECT OCD.ID
	,OCD.IdOrdenCompra
      ,OCD.IdProducto
      ,OCD.Nombre
      ,OCD.FlagAfecto
       ,CASE WHEN @IdVale IS NULL AND @IdImportacion IS NULL THEN
		 OCD.Cantidad
		ELSE
			(SELECT [ERP].[ObtenerCantidadTotalDetalleOrdenCompra](OCD.IdProducto, @IdOrdenCompra)) 
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
	  ,OC.IdMoneda
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
  WHERE OCD.IdOrdenCompra = @IdOrdenCompra AND (@IdVale IS NULL OR (SELECT [ERP].[ObtenerCantidadTotalDetalleOrdenCompra](OCD.IdProducto, @IdOrdenCompra)) != 0)

END