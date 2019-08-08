
CREATE PROC [ERP].[Usp_Sel_ValeDetalle_By_IdVale]
@IdVale INT
AS
BEGIN

	SELECT VD.ID
      ,VD.IdProducto
      ,VD.Nombre
      ,VD.FlagAfecto
      ,VD.Cantidad
      ,VD.PrecioUnitario
      ,VD.SubTotal
      ,VD.IGV
      ,VD.Total
      ,VD.IdVale
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat CodigoSunatUnidadMedida
	  ,M.Nombre NombreMarca
	  ,VD.Fecha
	  ,VD.NumeroLote
	  ,P.CodigoReferencia
  FROM [ERP].[ValeDetalle] VD
  INNER JOIN ERP.Producto P
		ON P.ID = VD.IdProducto
  INNER JOIN ERP.Vale V
	ON V.ID = VD.IdVale
  LEFT JOIN PLE.T6UnidadMedida UM
  	ON UM.ID = P.IdUnidadMedida
  LEFT JOIN Maestro.Marca M
  	ON M.ID = P.IdMarca
  WHERE VD.IdVale = @IdVale

END
