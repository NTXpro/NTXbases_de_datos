
CREATE PROC [ERP].[Usp_Sel_Producto] --1
@IdEmpresa INT
AS
BEGIN
		
	SELECT  PRO.ID,
			PRO.Nombre,
			M.Nombre NombreMarca,
			UM.Nombre NombreUnidadMedida,
			T5E.CodigoSunat
	FROM [ERP].[Producto] PRO
	LEFT JOIN Maestro.Marca M
		ON M.ID = PRO.IdMarca
	LEFT JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PRO.IdUnidadMedida
	LEFT JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia=T5E.ID
	WHERE PRO.Flag = 0 AND PRO.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa AND IdTipoProducto= 1

END

