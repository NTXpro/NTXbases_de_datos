
CREATE PROC [ERP].[Usp_Sel_Producto_By_Familia]
@IdFamilia INT,
@IdEmpresa INT
AS
BEGIN
		SELECT PRO.ID,
			   PRO.Nombre,
			   UM.Nombre UnidadMedida,
			   MA.Nombre Marca,
			   EX.Nombre Existencia
		FROM ERP.FamiliaProducto FP
		INNER JOIN ERP.Producto PRO ON PRO.ID = FP.IdProducto
		INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.ID
		LEFT JOIN Maestro.Marca MA ON MA.ID = PRO.IdMarca
		LEFT JOIN PLE.T5Existencia EX ON EX.ID = PRO.IdExistencia
		WHERE FP.IdFamilia = @IdFamilia AND FP.IdEmpresa = @IdEmpresa
END
