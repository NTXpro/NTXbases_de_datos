CREATE PROC [ERP].[Usp_Sel_Proyecto_Pagination] --1,1,20,'ASC','Nombre',20
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@IdEmpresa INT ,
@RowCount INT OUT
AS
BEGIN

	WITH Proyecto AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN PRO.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN PRO.Nombre END ASC,
			
			
			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN PRO.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN PRO.Nombre END DESC

		)
		AS ROWNUMBER,
			PRO.ID,
			PRO.Nombre			Nombre,
			PRO.Numero			Numero,
			PRO.FechaInicio,
			PRO.FechaFin       FechaFin,
			PRO.FechaEliminado
		FROM [ERP].[Proyecto] PRO
		INNER JOIN ERP.Empresa EM
		ON EM.ID=PRO.IdEmpresa
		WHERE PRO.Flag = @Flag AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa = @IdEmpresa
		)
			SELECT
				ID,
				Nombre,
				Numero,
				FechaInicio,
				FechaFin,
				FechaEliminado
			FROM Proyecto
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(PRO.ID)
				FROM [ERP].[Proyecto] PRO
				INNER JOIN ERP.Empresa EM
				ON EM.ID=PRO.IdEmpresa
				WHERE PRO.Flag = @Flag AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa = @IdEmpresa
			)
END
