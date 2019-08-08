CREATE PROC [ERP].[Usp_Sel_Marca_Pagination]
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN
		WITH MARCA AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN MA.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN MA.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN MA.FechaRegistro END ASC,

			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN MA.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN MA.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN MA.FechaRegistro END DESC
			
		)
		AS ROWNUMBER,
			MA.ID,
			MA.Nombre,
		    MA.FechaRegistro,
		    MA.FechaEliminado
		  
		FROM  Maestro.Marca MA
		WHERE MA.Flag = @Flag AND MA.FlagBorrador = 0
		)
			SELECT
				ID,
				Nombre,
				FechaRegistro,
				FechaEliminado
			FROM Marca
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(MA.ID)
				FROM  Maestro.Marca MA
				WHERE MA.Flag = @Flag AND MA.FlagBorrador = 0
			)
	SELECT MA.ID,
		   MA.Nombre,
		   MA.FechaRegistro,
		   MA.FechaEliminado
		  
	FROM  Maestro.Marca MA
	WHERE MA.Flag = @Flag AND MA.FlagBorrador = 0
END
