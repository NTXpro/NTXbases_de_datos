
CREATE PROC [ERP].[Usp_Sel_Producto_By_Nombre] 
@IdEmpresa INT,
@Nombre VARCHAR(250)
AS
BEGIN
		
	SELECT DISTINCT PRO.ID,
					PRO.Nombre,
					UPPER(pro.CodigoReferencia) AS CodigoReferencia,
					M.Nombre NombreMarca,
					UM.CodigoSunat CodigoSunatUnidadMedida,
					UM.Nombre NombreUnidadMedida,
					T5E.CodigoSunat,
					PRO.FlagIGVAfecto,
					M.Nombre Marca,
					UM.CodigoSunat UnidadMedida,
					T5E.CodigoSunat Existencia,
					PRO.FlagISC,
					PRO.IdTipoProducto
	FROM [ERP].[Producto] PRO
	LEFT JOIN Maestro.Marca M
		ON M.ID = PRO.IdMarca
	LEFT JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PRO.IdUnidadMedida
	LEFT JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia=T5E.ID
	WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0
	AND PRO.IdEmpresa = @IdEmpresa AND ((RTRIM(@Nombre) = '' OR RTRIM(PRO.Nombre) LIKE '%' + RTRIM(@Nombre) + '%') OR (RTRIM(@Nombre) = '' OR RTRIM(PRO.CodigoReferencia) LIKE '%' + RTRIM(@Nombre) + '%')) 

END
