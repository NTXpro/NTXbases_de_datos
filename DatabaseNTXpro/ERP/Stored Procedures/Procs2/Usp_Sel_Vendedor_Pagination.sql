
CREATE PROC [ERP].[Usp_Sel_Vendedor_Pagination]
@IdEmpresa INT,
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Vendedor AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN V.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN EN.Nombre END DESC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN V.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				V.ID,
				EN.Nombre,
				V.FechaRegistro,
				V.FechaEliminado,
				ETD.NumeroDocumento
		FROM ERP.Vendedor V
		INNER JOIN ERP.Trabajador T
			ON T.ID = V.IdTrabajador
		INNER JOIN ERP.Entidad EN
			ON EN.ID = T.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		WHERE V.Flag = @Flag AND V.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa
		)
		SELECT 
			ID,
			Nombre,
			FechaRegistro,
			FechaEliminado,
			NumeroDocumento
		FROM Vendedor
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(V.ID)
			FROM ERP.Vendedor V
			INNER JOIN ERP.Trabajador T
				ON T.ID = V.IdTrabajador
			INNER JOIN ERP.Entidad EN
				ON EN.ID = T.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
				ON ETD.IdEntidad = EN.ID
			WHERE V.Flag = @Flag AND V.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa
		)	

END

