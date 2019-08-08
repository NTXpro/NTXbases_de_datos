

CREATE PROC [ERP].[Usp_Sel_UnidadMedida_Pagination]
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN
	WITH UnidadMedida AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN UM.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN UM.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN UM.FechaRegistro END ASC,
			CASE WHEN(@SortType = 'CodigoSunat' AND @SortDir = 'ASC') THEN UM.CodigoSunat END ASC,

			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN UM.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN UM.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN UM.FechaRegistro END DESC,
			CASE WHEN(@SortType = 'CodigoSunat' AND @SortDir = 'DESC') THEN UM.CodigoSunat END DESC

			--DEFAULT				
			--CASE WHEN @SortType = '' THEN E.ID END ASC 	
		)
		AS ROWNUMBER,
			UM.ID,
			UM.Nombre,
			UM.FechaRegistro,
			UM.FechaEliminado,
			UM.CodigoSunat,
			UM.FlagSunat
		FROM [PLE].[T6UnidadMedida] UM
		WHERE UM.Flag = @Flag AND UM.FlagBorrador = 0
		)
			SELECT
				ID,
				Nombre,
				FechaRegistro,
				FechaEliminado,
				CodigoSunat,
				FlagSunat
			FROM UnidadMedida
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(UM.ID)
				FROM [PLE].[T6UnidadMedida] UM
				WHERE UM.Flag = @Flag AND UM.FlagBorrador = 0
			)
END
