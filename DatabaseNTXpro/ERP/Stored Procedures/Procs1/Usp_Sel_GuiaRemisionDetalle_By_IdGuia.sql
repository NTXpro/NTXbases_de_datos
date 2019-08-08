CREATE PROC [ERP].[Usp_Sel_GuiaRemisionDetalle_By_IdGuia]
@IdGuiaRemision INT
AS
BEGIN

		SELECT GRD.ID,
			   GRD.IdProducto,
			   GRD.Nombre,
			   GRD.Cantidad,
			   GRD.Peso,
			   GRD.Lote,
			   GRD.PesoUnitario,
			   GRD.PrecioUnitarioLista,
			   GRD.PrecioUnitarioListaSinIGV,
			   GRD.PrecioUnitarioValorISC,
			   GRD.PrecioUnitarioISC,
			   GRD.PrecioUnitarioSubTotal,
			   GRD.PrecioUnitarioIGV,
			   GRD.PrecioUnitarioTotal,
			   GRD.PrecioLista,
			   GRD.PrecioSubTotal,
			   GRD.PrecioIGV,
			   GRD.PrecioTotal,
			   GRD.FlagAfecto,
			   UM.CodigoSunat NombreUnidadMedida,
			   PRO.CodigoReferencia,
			   UM.CodigoSunat CodigoUnidadMedida
		FROM ERP.GuiaRemisionDetalle GRD
		INNER JOIN ERP.Producto PRO ON PRO.ID = GRD.IdProducto
		INNER JOIN PLE.T6UnidadMedida UM ON UM.ID = PRO.IdUnidadMedida
		WHERE IdGuiaRemision = @IdGuiaRemision
END
