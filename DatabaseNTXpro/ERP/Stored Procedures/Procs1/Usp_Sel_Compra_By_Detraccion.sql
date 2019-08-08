CREATE PROC [ERP].[Usp_Sel_Compra_By_Detraccion] 
@IdPeriodo INT,
@IdProveedor INT
AS
BEGIN
	
		SELECT CO.ID,
			   CO.Orden,
			   TC.Nombre TipoComprobante,
			   CO.Serie,
			   CO.FechaEmision,
			   ETD.NumeroDocumento
		FROM ERP.Compra CO
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CO.IdTipoComprobante
		INNER JOIN ERP.Proveedor PRO
		ON PRO.ID = CO.IdProveedor
		INNER JOIN ERP.Entidad EN
		ON EN.ID = PRO.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID 
		WHERE CO.IdPeriodo = @IdPeriodo AND CO.IdProveedor = @IdProveedor AND CO.FlagBorrador = 0 AND CO.Flag =1 AND CO.ID NOT IN (SELECT CO.ID FROM ERP.Percepcion PE INNER JOIN ERP.Compra CO ON CO.ID = PE.IdCompra )
END
