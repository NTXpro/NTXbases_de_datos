CREATE PROC [ERP].[Usp_Sel_Ultimos_Producto_By_Cliente_GuiaRemision]
@IdEntidad INT,
@IdEmpresa INT,
@IdListaPrecio INT
AS
BEGIN
	SELECT DISTINCT TOP 20 PRO.ID,
						   PRO.Nombre,
						   PRO.CodigoReferencia,
						   PRO.FlagISC,
						   PRO.FlagIGVAfecto,
						   LPD.PrecioUnitario,
						   LPD.PorcentajeDescuento,
						   MA.Nombre Marca,
						   UM.CodigoSunat UnidadMedida,
						   T5E.CodigoSunat Existencia
	FROM ERP.Producto PRO
	INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.IdUnidadMedida
	LEFT JOIN Maestro.Marca MA ON MA.ID = PRO.IdMarca
	LEFT JOIN PLE.T5Existencia T5E ON T5E.ID = PRO.IdExistencia
	INNER JOIN ERP.ListaPrecioDetalle LPD ON LPD.IdProducto = PRO.ID
	INNER JOIN ERP.ListaPrecio LP ON LP.ID = LPD.IdListaPrecio 
	INNER JOIN ERP.GuiaRemisionDetalle GRD ON GRD.IdProducto = PRO.ID
	INNER JOIN ERP.GuiaRemision GR ON GR.ID = GRD.IdGuiaRemision
	WHERE GR.IdEntidad = @IdEntidad AND GR.FlagBorrador = 0 AND GR.Flag = 1 
	AND GR.IdEmpresa = @IdEmpresa AND LP.ID = @IdListaPrecio
END
