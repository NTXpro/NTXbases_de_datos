CREATE PROC [ERP].[Usp_Sel_ListaPrecioDetalle_By_ID]
@IdListaPrecioDetalle INT
AS
BEGIN
	
	SELECT LPD.ID,
			IdListaPrecio,
			LPD.IdProducto,
			P.Nombre,
			PrecioUnitario,
			PorcentajeDescuento,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](P.IdEmpresa, 'VPU2', getdate())) AS FlagPrecioUnitario2Decimal
	FROM ERP.ListaPrecioDetalle LPD INNER JOIN ERP.Producto P
		ON P.ID = LPD.IdProducto
	WHERE LPD.ID = @IdListaPrecioDetalle
	
END
