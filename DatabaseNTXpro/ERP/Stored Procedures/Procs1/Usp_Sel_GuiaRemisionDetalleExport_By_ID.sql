CREATE PROC [ERP].[Usp_Sel_GuiaRemisionDetalleExport_By_ID] 
@IdGuiaRemision INT 
AS
BEGIN

		SELECT GRD.Cantidad,
			   GRD.Peso,
			   PRO.CodigoReferencia Codigo,
			   UM.CodigoSunat UnidadMedida,
			   ISNULL(GRD.Lote +'-','')+ GRD.Nombre Descripcion,
			   GRD.Nombre DescripcionSinLote,
			   GRD.PrecioUnitarioLista PrecioUnitario,
			   GRD.PrecioTotal ImporteTotal,
			   (SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](G.IdEmpresa, 'VPU2', G.Fecha)) AS FlagPrecio2Decimal
		FROM ERP.GuiaRemisionDetalle GRD
		INNER JOIN ERP.GuiaRemision G ON G.ID = GRD.IdGuiaRemision
		INNER JOIN ERP.Producto PRO ON PRO.ID = GRD.IdProducto
		INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.IdUnidadMedida
		WHERE GRD.IdGuiaRemision = @IdGuiaRemision
		
END