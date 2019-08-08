CREATE PROC [ERP].[Usp_Sel_Pedido_Emitida_By_IdCliente]
@IdEmpresa INT,
@IdCliente INT,
@Serie VARCHAR(4),
@Documento VARCHAR(8),
@OrdenCompra varchar (8)


AS
BEGIN
	SELECT	P.ID,
			P.Serie,
			P.Documento,
			P.Total,
			P.Fecha,
			P.IdTipoComprobante,
			TC.Nombre NombreTipoComprobante,
			PE.Nombre Estado,
			P.EstablecimientoDestino,
			RF.Documento  CodigoOrdenCompra
	FROM ERP.Pedido P
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = P.IdTipoComprobante
	LEFT JOIN Maestro.PedidoEstado PE ON PE.ID = P.IdPedidoEstado
    LEFT JOIN ERP.PedidoReferencia RF ON RF.IdPedido = P.ID
	WHERE P.IdEmpresa = @IdEmpresa 
	AND P.IdCliente = @IdCliente 
	AND (@Serie = '' OR P.Serie = @Serie) 
	AND (@Documento = '' OR P.Documento = @Documento)
	
	AND P.IdPedidoEstado IN (2, 4, 5)
END