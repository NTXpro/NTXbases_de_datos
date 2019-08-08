
CREATE PROC [ERP].[Usp_Sel_Cliente_Pagination]
@Flag BIT,
@IdEmpresa int,
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
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'ASC') THEN C.ID END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN C.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'DESC') THEN C.ID END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN EN.Nombre END DESC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN C.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				C.ID,
				EN.ID IdEntidad,
				EN.Nombre,
				C.FechaRegistro,
				C.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Cliente C
		INNER JOIN ERP.Entidad EN
			ON EN.ID = C.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa
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
			SELECT COUNT(C.ID)
			FROM ERP.Cliente C
			INNER JOIN ERP.Entidad EN
				ON EN.ID = C.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = EN.ID
			INNER JOIN PLE.T2TipoDocumento TD
				ON TD.ID = ETD.IdTipoDocumento
			WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa
		)	

END

