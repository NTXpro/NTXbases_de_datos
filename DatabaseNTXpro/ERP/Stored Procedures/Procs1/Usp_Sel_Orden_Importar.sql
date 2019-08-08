create PROC [ERP].[Usp_Sel_Orden_Importar] --28,1,1
@IdProveedor INT,
@IdEmpresa INT
AS
BEGIN
		DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.Proveedor WHERE ID = @IdProveedor)

		SELECT VA.ID,
			   VA.Fecha,


			   VA.Total,
			   VA.Serie,
			   VA.Documento,
			   MO.CodigoSunat Moneda,
			   VA.Total,

			   VA.IdTipoComprobante,
			   TC.Nombre		NombreComprobante
		FROM ERP.OrdenServicio VA
		INNER JOIN Maestro.Moneda MO ON MO.ID = VA.IdMoneda
		
		
		
		INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = VA.IdTipoComprobante
		WHERE  VA.IdEmpresa = @IdEmpresa 
		AND VA.FlagBorrador = 0 AND VA.Flag = 1 AND VA.IdOrdenServicioEstado=3 or VA.IdOrdenServicioEstado=6 
END