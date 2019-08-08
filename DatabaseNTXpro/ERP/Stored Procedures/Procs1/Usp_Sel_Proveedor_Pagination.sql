
CREATE PROC [ERP].[Usp_Sel_Proveedor_Pagination]
@IdEmpresa INT,
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Cliente AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'ASC') THEN P.ID END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN P.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'DESC') THEN P.ID END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN EN.Nombre END DESC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN P.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				P.ID,
				EN.ID IdEntidad,
				EN.Nombre,
				P.FechaRegistro,
				P.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Proveedor P
		INNER JOIN ERP.Entidad EN
			ON EN.ID = P.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE P.Flag = @Flag AND P.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa
		)
		SELECT 
			ID,
			IdEntidad,
			Nombre,
			FechaRegistro,
			FechaEliminado,
			NumeroDocumento,
			NombreTipoDocumento
		FROM Cliente
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(P.ID)
			FROM ERP.Proveedor P
			INNER JOIN ERP.Entidad EN
				ON EN.ID = P.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = EN.ID
			INNER JOIN PLE.T2TipoDocumento TD
				ON TD.ID = ETD.IdTipoDocumento
			WHERE P.Flag = @Flag AND P.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa
		)	

END

