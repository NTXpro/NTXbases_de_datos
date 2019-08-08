CREATE PROC [ERP].[Usp_Sel_OrdenCompraDetalle_Export]
@IdOrdenCompra INT
AS
BEGIN

	SELECT ROW_NUMBER() OVER(ORDER BY OCD.ID) AS Orden
      ,OCD.ID
      ,OCD.IdProducto
      ,OCD.Nombre
      ,OCD.FlagAfecto
      ,OCD.Cantidad
      ,OCD.PrecioUnitario
      ,OCD.SubTotal
      ,OCD.IGV
      ,OCD.Total
      ,OCD.IdOrdenCompra
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat CodigoSunatUnidadMedida
	  ,M.Nombre NombreMarca
	  ,P.CodigoReferencia
  FROM [ERP].[OrdenCompraDetalle] OCD
  INNER JOIN ERP.Producto P
		ON P.ID = OCD.IdProducto
  INNER JOIN ERP.OrdenCompra OC
	ON OC.ID = OCD.IdOrdenCompra
  LEFT JOIN PLE.T6UnidadMedida UM
  	ON UM.ID = P.IdUnidadMedida
  LEFT JOIN Maestro.Marca M
  	ON M.ID = P.IdMarca
  WHERE OCD.IdOrdenCompra = @IdOrdenCompra

END