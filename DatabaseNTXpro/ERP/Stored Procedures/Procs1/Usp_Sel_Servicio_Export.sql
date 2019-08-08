CREATE PROCEDURE [ERP].[Usp_Sel_Servicio_Export]     
@Flag bit,
@IdEmpresa int
AS
BEGIN
SELECT    
			SER.ID,
			SER.Nombre,
			T6U.CodigoSunat AS 'UnidadMedida',
			T5E.CodigoSunat AS 'CodigoExistencia',
			SER.FechaRegistro,
			SER.FechaEliminado
		FROM [ERP].[Producto] SER
		INNER JOIN PLE.T6UnidadMedida T6U
		ON SER.IdUnidadMedida=T6U.ID
		INNER JOIN Maestro.Marca MA
		ON SER.IdMarca = MA.ID
		INNER JOIN PLE.T5Existencia T5E
		ON SER.IdExistencia  = T5E.ID
		INNER JOIN Maestro.TipoProducto TP
		ON SER.IdTipoProducto=TP.ID
		WHERE SER.Flag = @Flag AND SER.FlagBorrador = 0 AND SER.IdEmpresa = @IdEmpresa AND SER.IdTipoProducto = 2
END
