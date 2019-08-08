
CREATE PROC [ERP].[Usp_Sel_OrdenServicioDetalle_Export]
@IdOrdenServicio INT
AS
BEGIN

	SELECT OCD.ID
      ,OCD.IdProducto
      ,OCD.Nombre
      ,OCD.FlagAfecto
      ,OCD.Cantidad
      ,OCD.PrecioUnitario
      ,OCD.SubTotal
      ,OCD.IGV
      ,OCD.Total
      ,OCD.IdOrdenServicio
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat CodigoSunatUnidadMedida
	  ,M.Nombre NombreMarca
	  ,P.CodigoReferencia
  FROM [ERP].[OrdenServicioDetalle] OCD
  INNER JOIN ERP.Producto P
		ON P.ID = OCD.IdProducto
  INNER JOIN ERP.OrdenServicio OC
	ON OC.ID = OCD.IdOrdenServicio
  LEFT JOIN PLE.T6UnidadMedida UM
  	ON UM.ID = P.IdUnidadMedida
  LEFT JOIN Maestro.Marca M
  	ON M.ID = P.IdMarca
  WHERE OCD.IdOrdenServicio = @IdOrdenServicio

END