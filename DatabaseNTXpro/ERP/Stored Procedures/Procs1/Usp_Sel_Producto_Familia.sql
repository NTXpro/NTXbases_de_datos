CREATE PROC [ERP].[Usp_Sel_Producto_Familia]
@IdFamilia INT,
@IdEmpresa INT
AS
BEGIN

		SELECT PRO.ID,
			   PRO.Nombre,
			   UM.Nombre UnidadMedida,
			   MA.Nombre Marca,
			   EX.Nombre Existencia
		FROM ERP.Producto PRO
		INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.ID
		LEFT JOIN Maestro.Marca MA ON MA.ID = PRO.IdMarca
		LEFT JOIN PLE.T5Existencia EX ON EX.ID = PRO.IdExistencia
		WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND PRO.IdTipoProducto = 1 AND PRO.IdEmpresa = @IdEmpresa
		AND PRO.ID NOT IN (SELECT IdProducto FROM ERP.FamiliaProducto WHERE IdEmpresa = @IdEmpresa)
END
