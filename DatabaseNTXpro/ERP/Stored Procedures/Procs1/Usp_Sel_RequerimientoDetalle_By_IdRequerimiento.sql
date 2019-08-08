
CREATE PROC [ERP].[Usp_Sel_RequerimientoDetalle_By_IdRequerimiento]
@IdRequerimiento INT
AS
BEGIN

SELECT RD.ID
      ,RD.IdRequerimiento
      ,RD.IdProducto
      ,RD.Nombre
      ,RD.Cantidad
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat  CodigoSunatUnidadMedida
	  ,P.CodigoReferencia CodigoProducto
  FROM ERP.RequerimientoDetalle RD
  LEFT JOIN ERP.Producto P ON P.ID = RD.IdProducto
  LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
  WHERE RD.IdRequerimiento = @IdRequerimiento
END
