

CREATE PROC [Seguridad].[Usp_Sel_Usuario_Pagination]
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
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'ASC') THEN U.ID END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
				CASE WHEN (@SortType = 'Correo' AND @SortDir = 'ASC') THEN U.Correo END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN U.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'ID' AND @SortDir = 'DESC') THEN U.ID END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN EN.Nombre END DESC,
				CASE WHEN (@SortType = 'Correo' AND @SortDir = 'ASC') THEN U.Correo END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN U.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				U.ID,
				EN.Nombre,
				U.Correo,
				U.FechaRegistro,
				U.FechaEliminado,
				U.FlagAdministrador,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM Seguridad.Usuario U
		INNER JOIN ERP.Entidad EN
			ON EN.ID = U.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE U.Flag = @Flag AND U.FlagBorrador = 0
		)
		SELECT 
			ID,
			Nombre,
			Correo,
			FechaRegistro,
			FlagAdministrador,
			FechaEliminado,
			NumeroDocumento,
			NombreTipoDocumento
		FROM Empresa
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(U.ID)
			FROM Seguridad.Usuario U
			INNER JOIN ERP.Entidad EN
				ON EN.ID = U.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = EN.ID
			INNER JOIN PLE.T2TipoDocumento TD
				ON TD.ID = ETD.IdTipoDocumento
			WHERE U.Flag = @Flag AND U.FlagBorrador = 0
		)	

END

