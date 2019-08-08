
CREATE PROC [ERP].[Usp_Sel_Servicio] --1
@IdEmpresa INT
AS
BEGIN
		
	SELECT  PRO.ID,
			PRO.Nombre,
			M.Nombre NombreMarca,
			UM.Nombre NombreUnidadMedida,
			T5E.CodigoSunat
	FROM [ERP].[Producto] PRO
	INNER JOIN Maestro.Marca M
		ON M.ID = PRO.IdMarca
	INNER JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PRO.IdUnidadMedida
	INNER JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia=T5E.ID
	WHERE PRO.Flag = 0 AND PRO.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa AND IdTipoProducto= 2

END

