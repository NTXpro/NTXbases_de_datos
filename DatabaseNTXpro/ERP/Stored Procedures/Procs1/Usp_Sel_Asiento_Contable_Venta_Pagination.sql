CREATE PROC [ERP].[Usp_Sel_Asiento_Contable_Venta_Pagination] --1, 11,1,10,'ASC','Orden',10
@Anio INT,
@IdMes INT,
@IdEmpresa INT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN
	
	DECLARE @IdAnio INT = (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio)
	DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes);

	WITH AsientoContable AS
	(
		SELECT 
				A.ID,
				C.ID IdComprobante,
				C.IdTipoComprobante,
				RIGHT('00000000' + CAST(A.Orden AS VARCHAR(8)), 8) Orden,
				TC.Nombre NombreTipoComprobante,
				C.Serie,
				C.Documento,
				C.Fecha,
				M.CodigoSunat Moneda,
				C.TipoCambio,
				C.Total,
				E.Nombre NombreCliente,
				TD.Abreviatura + ' ' + ETD.NumeroDocumento AS DocumentoCliente,
				(SELECT [ERP].[ObtenerTotalDebe_By_Asiento](A.ID)) AS DEBE,
				(SELECT [ERP].[ObtenerTotalHaber_By_Asiento](A.ID)) AS HABER,
				(SELECT [ERP].[ValidarAsientoIncompleto](A.ID)) FlagAsientoIncompleto
		FROM ERP.Asiento A
		INNER JOIN ERP.Comprobante C
			ON C.IdAsiento = A.ID
		INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = C.IdTipoComprobante
		INNER JOIN Maestro.Moneda M
			ON M.ID = C.IdMoneda
		INNER JOIN ERP.Cliente CLI
			ON CLI.ID = C.IdCliente
		INNER JOIN ERP.Entidad E
			ON E.ID = CLI.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = E.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE IdPeriodo = @IdPeriodo AND A.IdEmpresa = @IdEmpresa
	),
	AsientoContablePagination AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'Orden' AND @SortDir = 'ASC') THEN Orden END ASC,
				CASE WHEN (@SortType = 'NombreTipoComprobante' AND @SortDir = 'ASC') THEN NombreTipoComprobante END ASC,
				CASE WHEN (@SortType = 'Serie' AND @SortDir = 'ASC') THEN Serie END ASC,
				CASE WHEN (@SortType = 'Documento' AND @SortDir = 'ASC') THEN Documento END ASC,
				CASE WHEN (@SortType = 'Fecha' AND @SortDir = 'ASC') THEN Fecha END ASC,
				CASE WHEN (@SortType = 'Moneda' AND @SortDir = 'ASC') THEN Moneda END ASC,
				CASE WHEN (@SortType = 'TipoCambio' AND @SortDir = 'ASC') THEN TipoCambio END ASC,
				CASE WHEN (@SortType = 'Total' AND @SortDir = 'ASC') THEN Total END ASC,
				CASE WHEN (@SortType = 'NombreCliente' AND @SortDir = 'ASC') THEN NombreCliente END ASC,
				CASE WHEN (@SortType = 'DocumentoCliente' AND @SortDir = 'ASC') THEN NombreCliente END ASC,
				CASE WHEN (@SortType = 'DEBE' AND @SortDir = 'ASC') THEN NombreCliente END ASC,
				CASE WHEN (@SortType = 'HABER' AND @SortDir = 'ASC') THEN NombreCliente END ASC,
				--DESC
				CASE WHEN (@SortType = 'Orden' AND @SortDir = 'DESC') THEN Orden END DESC,
				CASE WHEN (@SortType = 'NombreTipoComprobante' AND @SortDir = 'DESC') THEN NombreTipoComprobante END DESC,
				CASE WHEN (@SortType = 'Serie' AND @SortDir = 'DESC') THEN Serie END DESC,
				CASE WHEN (@SortType = 'Documento' AND @SortDir = 'DESC') THEN Documento END DESC,
				CASE WHEN (@SortType = 'Fecha' AND @SortDir = 'DESC') THEN Fecha END DESC,
				CASE WHEN (@SortType = 'Moneda' AND @SortDir = 'DESC') THEN Moneda END DESC,
				CASE WHEN (@SortType = 'TipoCambio' AND @SortDir = 'DESC') THEN TipoCambio END DESC,
				CASE WHEN (@SortType = 'Total' AND @SortDir = 'DESC') THEN Total END DESC,
				CASE WHEN (@SortType = 'NombreCliente' AND @SortDir = 'DESC') THEN NombreCliente END DESC,
				CASE WHEN (@SortType = 'DocumentoCliente' AND @SortDir = 'DESC') THEN NombreCliente END DESC,
				CASE WHEN (@SortType = 'DEBE' AND @SortDir = 'DESC') THEN NombreCliente END DESC,
				CASE WHEN (@SortType = 'HABER' AND @SortDir = 'DESC') THEN NombreCliente END DESC
			)	
			AS ROWNUMBER,
				ID,
				IdComprobante,
				IdTipoComprobante,
				Orden,
				NombreTipoComprobante,
				Serie,
				Documento,
				Fecha,
				Moneda,
				TipoCambio,
				Total,
				NombreCliente,
				DocumentoCliente,
				DEBE,
				HABER,
				FlagAsientoIncompleto
			FROM AsientoContable
		)
		SELECT 
			ID,
			IdComprobante,
			IdTipoComprobante,
			Orden,
			NombreTipoComprobante,
			Serie,
			Documento,
			Fecha,
			Moneda,
			TipoCambio,
			Total,
			NombreCliente,
			DocumentoCliente,
			DEBE,
			HABER,
			FlagAsientoIncompleto
		FROM AsientoContablePagination
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(A.ID)
			FROM ERP.Asiento A
			INNER JOIN ERP.Comprobante C
				ON C.IdAsiento = A.ID
			INNER JOIN PLE.T10TipoComprobante TC
				ON TC.ID = C.IdTipoComprobante
			INNER JOIN Maestro.Moneda M
				ON M.ID = C.IdMoneda
			INNER JOIN ERP.Cliente CLI
				ON CLI.ID = C.IdCliente
			INNER JOIN ERP.Entidad E
				ON E.ID = CLI.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = E.ID
			INNER JOIN PLE.T2TipoDocumento TD
				ON TD.ID = ETD.IdTipoDocumento
			WHERE IdPeriodo = @IdPeriodo
		)	

END
