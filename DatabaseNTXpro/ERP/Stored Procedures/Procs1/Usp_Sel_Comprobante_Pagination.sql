
CREATE PROC [ERP].[Usp_Sel_Comprobante_Pagination]
@Flag BIT,
@IdTipoComprobante INT,
@IdEmpresa INT,
@Mes INT,
@Anio INT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Factura AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'Serie' AND @SortDir = 'ASC') THEN LTRIM(C.Serie) END ASC,
				CASE WHEN (@SortType = 'Documento' AND @SortDir = 'ASC') THEN C.Documento END ASC,
				CASE WHEN (@SortType = 'Fecha' AND @SortDir = 'ASC') THEN C.Fecha END ASC,
				CASE WHEN (@SortType = 'Estado' AND @SortDir = 'ASC') THEN C.IdComprobanteEstado END ASC,
				CASE WHEN (@SortType = 'Total' AND @SortDir = 'ASC') THEN C.Total END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN E.Nombre END ASC,
				CASE WHEN (@SortType = 'NumeroDocumentoCliente' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'NombreTipoDocumento' AND @SortDir = 'ASC') THEN TD.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'Serie' AND @SortDir = 'DESC') THEN LTRIM(C.Serie) END DESC,
				CASE WHEN (@SortType = 'Documento' AND @SortDir = 'DESC') THEN C.Documento END DESC,
				CASE WHEN (@SortType = 'Fecha' AND @SortDir = 'DESC') THEN C.Fecha END DESC,
				CASE WHEN (@SortType = 'Estado' AND @SortDir = 'DESC') THEN C.IdComprobanteEstado END DESC,
				CASE WHEN (@SortType = 'Total' AND @SortDir = 'DESC') THEN C.Total END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN E.Nombre END DESC,
				CASE WHEN (@SortType = 'NumeroDocumentoCliente' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'NombreTipoDocumento' AND @SortDir = 'DESC') THEN TD.Nombre END DESC,
				CASE WHEN (@SortType = 'Inicio' AND @SortDir = 'DESC') THEN CAST(C.Fecha AS VARCHAR(20))+C.Serie+C.Documento END DESC
				
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				C.ID,
				C.Serie,
				C.Documento,
				C.Fecha,
				C.IdComprobanteEstado,
				C.Total,
				E.Nombre,
				ETD.NumeroDocumento NumeroDocumentoCliente,
				TD.Abreviatura NombreTipoDocumento
		FROM ERP.Comprobante C INNER JOIN ERP.Cliente CLI
			ON CLI.ID = C.IdCliente
		INNER JOIN ERP.Entidad E
			ON E.ID = CLI.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = E.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa AND C.IdTipoComprobante = @IdTipoComprobante
			  AND (@Flag = 0 OR (MONTH(C.Fecha) = @Mes AND YEAR(C.FECHA) = @Anio))
		)
		SELECT 
			ID,
			Serie,
			Documento,
			Fecha,
			IdComprobanteEstado,
			Total,
			Nombre,
			NumeroDocumentoCliente,
			NombreTipoDocumento
		FROM Factura
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(C.ID)
			FROM ERP.Comprobante C INNER JOIN ERP.Cliente CLI
				ON CLI.ID = C.IdCliente
			INNER JOIN ERP.Entidad E
				ON E.ID = CLI.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = E.ID
			INNER JOIN PLE.T2TipoDocumento TD
				ON TD.ID = ETD.IdTipoDocumento
			WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa AND C.IdTipoComprobante = @IdTipoComprobante
			AND MONTH(C.Fecha) = @Mes AND YEAR(C.FECHA) = @Anio
		)	 

END

