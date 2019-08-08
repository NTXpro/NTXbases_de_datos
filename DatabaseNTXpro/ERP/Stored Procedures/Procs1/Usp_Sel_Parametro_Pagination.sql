CREATE PROC [ERP].[Usp_Sel_Parametro_Pagination]
@Flag BIT,
@IdEmpresa INT, 
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Parametro AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN PA.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN PA.Nombre END ASC,
			CASE WHEN(@SortType = 'NombreTipoParametro' AND @SortDir = 'ASC') THEN TPA.Nombre END ASC,
			CASE WHEN(@SortType = 'Valor' AND @SortDir = 'ASC') THEN PA.Valor END ASC,
		
			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN PA.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN PA.Nombre END DESC,
			CASE WHEN(@SortType = 'NombreTipoParametro' AND @SortDir = 'DESC') THEN TPA.Nombre END DESC,
			CASE WHEN(@SortType = 'Valor' AND @SortDir = 'DESC') THEN PA.Valor END DESC

			--DEFAULT				
			--CASE WHEN @SortType = '' THEN E.ID END ASC 	
		)
		AS ROWNUMBER,
			PA.ID											,
			PA.Nombre										NombreParametro,
			PA.Abreviatura									Abreviatura,
			PA.Valor										Valor,
			TPA.Nombre										NombreTipoParametro
		FROM [ERP].[Parametro] PA
		INNER JOIN [ERP].[Periodo] PE
		ON PE.ID=PA.IdPeriodo
		INNER JOIN [Maestro].[TipoParametro] TPA
		ON TPA.ID=PA.IdTipoParametro
		WHERE PA.Flag=@Flag AND (PA.IdEmpresa = @IdEmpresa OR PA.IdTipoParametro = 1)
		)
			SELECT
				ID,
				NombreParametro,
				Abreviatura,
				Valor,
				NombreTipoParametro
			FROM Parametro
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(PA.ID)
				FROM [ERP].[Parametro] PA
				INNER JOIN [ERP].[Periodo] PE
				ON PE.ID=PA.IdPeriodo
				INNER JOIN [Maestro].[TipoParametro] TPA
				ON TPA.ID=PA.IdTipoParametro
				WHERE PA.Flag=@Flag AND (PA.IdEmpresa = @IdEmpresa OR PA.IdTipoParametro = 1)
			)
END
