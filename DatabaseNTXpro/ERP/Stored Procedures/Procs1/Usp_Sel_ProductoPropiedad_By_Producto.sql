CREATE PROC ERP.Usp_Sel_ProductoPropiedad_By_Producto
@IdProducto INT,
@TipoProducto INT
AS
BEGIN

SELECT PP.IdProducto,
	   PP.IdPropiedad,
	   PRO.Nombre,
	   UM.Nombre NombreUnidadMedida,
	   UM.CodigoSunat CodigoSunatUnidadMedida,
	   PP.Valor
FROM Maestro.Propiedad PRO
INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.IdUnidadMedida
LEFT JOIN ERP.ProductoPropiedad PP ON PRO.ID = PP.IdPropiedad
LEFT JOIN ERP.Producto PR ON PR.ID = PP.IdProducto
WHERE PR.ID = @IdProducto AND PR.IdTipoProducto = @TipoProducto
UNION 
SELECT NULL IdProducto,
	   PRO.ID,
	   PRO.Nombre,
	   UM.Nombre NombreUnidadMedida,
	   UM.CodigoSunat CodigoSunatUnidadMedida,
	   NULL Valor
FROM Maestro.Propiedad PRO
INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.IdUnidadMedida
WHERE PRO.ID NOT IN (SELECT IdPropiedad FROM ERP.ProductoPropiedad PP WHERE PP.IdProducto = @IdProducto)

END
