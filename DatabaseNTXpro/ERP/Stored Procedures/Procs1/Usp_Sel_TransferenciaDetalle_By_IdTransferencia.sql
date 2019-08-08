
CREATE PROC [ERP].[Usp_Sel_TransferenciaDetalle_By_IdTransferencia]
@IdTransferencia INT
AS
BEGIN

	SELECT TD.ID
      ,TD.IdProducto
      ,TD.Nombre
      ,TD.FlagAfecto
      ,TD.Cantidad
      ,TD.PrecioUnitario
      ,TD.SubTotal
      ,TD.IGV
      ,TD.Total
      ,TD.IdValeTransferencia
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat CodigoSunatUnidadMedida
	  ,M.Nombre NombreMarca
	  ,TD.Fecha
	  ,TD.NumeroLote
	  ,P.CodigoReferencia
  FROM [ERP].[ValeTransferenciaDetalle] TD
  INNER JOIN ERP.Producto P
		ON P.ID = TD.IdProducto
  INNER JOIN ERP.ValeTransferencia VT
	ON VT.ID = TD.IdValeTransferencia
  LEFT JOIN PLE.T6UnidadMedida UM
  	ON UM.ID = P.IdUnidadMedida
  LEFT JOIN Maestro.Marca M
  	ON M.ID = P.IdMarca
  WHERE TD.IdValeTransferencia = @IdTransferencia

END
