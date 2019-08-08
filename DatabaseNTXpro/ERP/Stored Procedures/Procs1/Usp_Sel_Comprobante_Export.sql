
CREATE PROC [ERP].[Usp_Sel_Comprobante_Export]
@IdTipoComprobante INT,
@IdEmpresa INT,
@Mes INT,
@Anio INT
AS
BEGIN

		SELECT
				C.ID,
				TC.Nombre NombreTipoComprobante,
				C.Serie,
				C.Documento,
				C.Fecha,
				C.IdComprobanteEstado,
				C.Total,
				E.Nombre,
				ETD.NumeroDocumento NumeroDocumentoCliente,
				TD.Abreviatura NombreTipoDocumento,
				CE.Nombre as NombreEstado
		FROM ERP.Comprobante C INNER JOIN ERP.Cliente CLI
			ON CLI.ID = C.IdCliente
		INNER JOIN Maestro.ComprobanteEstado CE
			ON CE.ID = C.IdComprobanteEstado
		INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = C.IdTipoComprobante
		INNER JOIN ERP.Entidad E
			ON E.ID = CLI.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = E.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE C.Flag = 1 AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa AND C.IdTipoComprobante = @IdTipoComprobante
			  AND ((MONTH(C.Fecha) = @Mes AND YEAR(C.FECHA) = @Anio))
	
END

