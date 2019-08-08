CREATE PROCEDURE [ERP].[Usp_Sel_Producto_Export]
@Flag bit,
@IdEmpresa int
AS
BEGIN
SELECT            
			
			PRO.ID,
			PRO.Nombre,
			T6U.CodigoSunat		UnidadMedida,
			T6U.Nombre			NombreUnidadMedida,
			T5E.CodigoSunat		CodigoExistencia,
			PRO.FechaRegistro,
			PRO.FechaEliminado
		FROM [ERP].[Producto] PRO
		INNER JOIN PLE.T6UnidadMedida T6U
		ON PRO.IdUnidadMedida=T6U.ID
		INNER JOIN Maestro.Marca MA
		ON PRO.IdMarca = MA.ID
		INNER JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia  = T5E.ID
		INNER JOIN Maestro.TipoProducto TP
		ON PRO.IdTipoProducto=TP.ID
		WHERE PRO.Flag = @Flag AND PRO.FlagBorrador = 0 AND PRO.IdTipoProducto= 1 AND PRO.IdEmpresa = @IdEmpresa
END
