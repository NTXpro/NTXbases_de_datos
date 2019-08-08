

CREATE PROC [ERP].[Usp_Sel_Banco_Pagination]
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Banco AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'ASC') THEN B.ID END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN B.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'DESC') THEN B.ID END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN EN.Nombre END DESC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN B.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				B.ID,
				EN.ID IdEntidad,
				EN.Nombre,
				B.FechaRegistro,
				B.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
			FROM [PLE].[T3Banco] B
		INNER JOIN ERP.Entidad EN
			ON EN.ID = B.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE B.Flag = @Flag AND B.FlagBorrador = 0
		)
		SELECT 
			ID,
			IdEntidad,
			Nombre,
			FechaRegistro,
			FechaEliminado,
			NumeroDocumento,
			NombreTipoDocumento
		FROM Banco
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(B.ID)
				FROM [PLE].[T3Banco] B
				INNER JOIN ERP.Entidad EN
					ON EN.ID = B.IdEntidad
				INNER JOIN ERP.EntidadTipoDocumento ETD
					ON ETD.IdEntidad = EN.ID
				INNER JOIN PLE.T2TipoDocumento TD
					ON TD.ID = ETD.IdTipoDocumento
			WHERE B.Flag = @Flag AND B.FlagBorrador = 0
		)	

END

