
CREATE PROC [ERP].[Usp_Sel_Existencia_Pagination]
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN


	WITH Existencia AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN EX.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN EX.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN EX.FechaRegistro END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN EX.CodigoSunat END ASC,

			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN EX.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN EX.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN EX.FechaRegistro END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN EX.CodigoSunat END DESC

			--DEFAULT				
			--CASE WHEN @SortType = '' THEN E.ID END ASC 	
		)
		AS ROWNUMBER,
			EX.ID,
			EX.Nombre,
			EX.FechaRegistro,
			EX.FechaEliminado,
			EX.CodigoSunat,
			EX.FlagSunat	
		FROM [PLE].[T5Existencia] EX
		WHERE EX.Flag = @Flag AND EX.FlagBorrador = 0
		)
			SELECT
				ID,
				Nombre,
				FechaRegistro,
				FechaEliminado,
				CodigoSunat,
				FlagSunat
			FROM Existencia
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(EX.ID)
				FROM [PLE].[T5Existencia] EX
				WHERE EX.Flag = @Flag AND EX.FlagBorrador = 0
			)
END
