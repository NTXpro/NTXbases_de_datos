
CREATE PROC [ERP].[Usp_Sel_Empresa_Pagination]
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Empresa AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'ASC') THEN E.ID END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN LTRIM(EN.Nombre) END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN E.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'DESC') THEN E.ID END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN LTRIM(EN.Nombre) END DESC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN E.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				E.ID,
				LTRIM(EN.Nombre) Nombre,
				E.FechaRegistro,
				E.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento,
				E.FlagPrincipal
		FROM ERP.Empresa E
		INNER JOIN ERP.Entidad EN
			ON EN.ID = E.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE E.Flag = @Flag AND E.FlagBorrador = 0
		)
		SELECT 
			ID,
			Nombre,
			FechaRegistro,
			FechaEliminado,
			NumeroDocumento,
			NombreTipoDocumento,
			FlagPrincipal
		FROM Empresa
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(E.ID)
			FROM ERP.Empresa E
			INNER JOIN ERP.Entidad EN
				ON EN.ID = E.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = EN.ID
			INNER JOIN PLE.T2TipoDocumento TD
				ON TD.ID = ETD.IdTipoDocumento
			WHERE E.Flag = @Flag AND E.FlagBorrador = 0
		)	

END

