CREATE PROC [ERP].[Usp_Sel_Servicio_Borrador_Pagination]
@IdEmpresa INT
AS
BEGIN

	SELECT SER.ID,
			SER.Nombre,
			T6U.CodigoSunat,
			T5E.CodigoSunat
			--TP.Nombre
	FROM [ERP].[Producto] SER
	LEFT JOIN PLE.T6UnidadMedida T6U
	ON SER.IdUnidadMedida=T6U.ID
	LEFT JOIN Maestro.Marca MA
	ON SER.IdMarca = MA.ID
	LEFT JOIN PLE.T5Existencia T5E
	ON SER.IdExistencia  = T5E.ID
	LEFT JOIN Maestro.TipoProducto TP
	ON SER.IdTipoProducto=TP.ID
	WHERE SER.FlagBorrador = 1 AND SER.IdTipoProducto = 2 AND SER.IdEmpresa = @IdEmpresa
END
