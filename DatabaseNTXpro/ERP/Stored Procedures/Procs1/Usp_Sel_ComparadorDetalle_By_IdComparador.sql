CREATE PROC [ERP].[Usp_Sel_ComparadorDetalle_By_IdComparador]
@IdComparador int
AS
BEGIN
SELECT CD.[ID]
      ,CD.[IdComparador]
      ,CD.[IdProducto]
      ,CD.[IdProveedor]
      ,CD.[Cantidad]
      ,CD.[Precio]
      ,CD.[Total]
	  ,CD.Seleccionado
	  ,P.CodigoReferencia AS CodigoProducto
	  ,UM.Nombre as UnidadMedida
	  ,P.Nombre AS NombreProducto
	  ,E.Nombre AS NombreProveedor
	  ,ETD.NumeroDocumento
	  ,TD.Abreviatura AS TipoDocumento
	  ,PRO.Correo
  FROM [ERP].[ComparadorDetalle] CD
  LEFT JOIN ERP.Producto P ON P.ID = CD.IdProducto
  LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
  LEFT JOIN ERP.Proveedor PRO ON PRO.ID = CD.IdProveedor
  LEFT JOIN ERP.Entidad E ON E.ID = PRO.IdEntidad
  LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
  LEFT JOIN [PLE].[T2TipoDocumento] TD ON TD.ID = ETD.IdTipoDocumento
  WHERE IdComparador = @IdComparador
  END