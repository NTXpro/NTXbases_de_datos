CREATE PROC [ERP].[Usp_Sel_Producto_By_Nombre_GuiaRemision]
@IdEmpresa INT,
@Nombre VARCHAR(250),
@IdListaPrecio INT
AS
BEGIN
		
	SELECT  PRO.ID,
			PRO.Nombre,
			PRO.Peso,
			PRO.CodigoReferencia,
			PRO.FlagIGVAfecto,
			LPD.PrecioUnitario,
			LPD.PorcentajeDescuento,
			M.Nombre Marca,
			UM.CodigoSunat UnidadMedida,
			T5E.CodigoSunat Existencia,
			PRO.FlagISC
	FROM ERP.Producto PRO
	LEFT JOIN Maestro.Marca M ON M.ID = PRO.IdMarca
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = PRO.IdUnidadMedida
	LEFT JOIN PLE.T5Existencia T5E ON PRO.IdExistencia=T5E.ID
	INNER JOIN ERP.ListaPrecioDetalle LPD ON LPD.IdProducto = PRO.ID
	INNER JOIN ERP.ListaPrecio LP ON LP.ID = LPD.IdListaPrecio 
	WHERE PRO.Flag = 1 
	AND PRO.FlagBorrador = 0 
	AND LP.ID = @IdListaPrecio
	AND PRO.IdEmpresa = @IdEmpresa 
	AND PRO.IdTipoProducto = 1
	AND ((RTRIM(@Nombre) = '' OR RTRIM(PRO.Nombre) LIKE '%' + RTRIM(@Nombre) + '%') OR (RTRIM(@Nombre) = '' OR RTRIM(PRO.CodigoReferencia) LIKE '%' + RTRIM(@Nombre) + '%')) 
END