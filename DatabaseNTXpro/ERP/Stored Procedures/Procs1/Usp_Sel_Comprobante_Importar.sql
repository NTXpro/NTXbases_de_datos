
CREATE PROC [ERP].[Usp_Sel_Comprobante_Importar] 
@IdEntidad INT,
@IdEmpresa INT
AS
BEGIN
		DECLARE @IdCliente INT = (SELECT ID FROM ERP.Cliente WHERE IdEntidad =@IdEntidad );

		SELECT CO.ID,
			   CO.Fecha,
			   CO.Total,
			   CO.Serie,
			   CO.Documento,
			   MO.CodigoSunat Moneda,
			   CO.Total,
			   CO.IdTipoComprobante,
			   CO.IdTipoComprobante,
			   TC.Nombre		NombreComprobante,
			   MO.CodigoSunat	Moneda
		FROM ERP.Comprobante CO
		INNER JOIN Maestro.Moneda MO ON MO.ID = CO.IdMoneda
		INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CO.IdTipoComprobante
		WHERE CO.IdCliente = @IdCliente AND CO.IdEmpresa = @IdEmpresa 
		AND CO.FlagBorrador = 0 AND CO.Flag = 1 AND CO.IdComprobanteEstado = 2
		AND CO.IdTipoComprobante IN (2,4)
END
