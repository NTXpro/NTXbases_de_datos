CREATE PROC [ERP].[Usp_Sel_Propiedad_Pagination] 
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Propiedad AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN PR.ID END ASC,
			CASE WHEN(@SortType = 'NombrePropiedad' AND @SortDir = 'ASC') THEN PR.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN PR.FechaRegistro END ASC,
			CASE WHEN(@SortType = 'NombreUnidadMedida' AND @SortDir = 'ASC') THEN UM.Nombre END ASC,
			CASE WHEN(@SortType = 'IdUnidadMedida' AND @SortDir = 'ASC') THEN UM.ID END ASC,
			CASE WHEN(@SortType = 'CodigoSunat' AND @SortDir = 'ASC') THEN UM.CodigoSunat END ASC,

			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN PR.ID END DESC,
			CASE WHEN(@SortType = 'NombrePropiedad' AND @SortDir = 'ASC') THEN PR.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN PR.FechaRegistro END DESC,
			CASE WHEN(@SortType = 'NombreUnidadMedida' AND @SortDir = 'ASC') THEN UM.Nombre END DESC,
			CASE WHEN(@SortType = 'IdUnidadMedida' AND @SortDir = 'ASC') THEN UM.ID END DESC,
			CASE WHEN(@SortType = 'CodigoSunat' AND @SortDir = 'ASC') THEN UM.CodigoSunat END DESC

		)
		AS ROWNUMBER,
			PR.ID											,
			UM.ID											IdUnidadMedida,
			PR.Nombre										NombrePropiedad,
			UM.Nombre										NombreUnidadMedida,
			UM.CodigoSunat									CodigoSunat,
			PR.FechaRegistro								FechaRegistro
		FROM [Maestro].[Propiedad] PR
		INNER JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PR.IdUnidadMedida
		WHERE PR.Flag = @Flag AND PR.FlagBorrador = 0
		)
			SELECT
				ID,
				NombrePropiedad,
				FechaRegistro,
				NombreUnidadMedida,
				IdUnidadMedida,
				CodigoSunat
				
			FROM Propiedad
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(PR.ID)
				FROM [Maestro].[Propiedad] PR
				INNER JOIN [PLE].[T6UnidadMedida] UM
				ON UM.ID = PR.IdUnidadMedida
				WHERE PR.Flag = @Flag AND PR.FlagBorrador = 0
			)
END