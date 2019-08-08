CREATE PROC [ERP].[Usp_Sel_Rol_Pagination] 
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH ROL AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN RO.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN RO.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN RO.FechaRegistro END ASC,

			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN RO.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN RO.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN RO.FechaRegistro END DESC

			--DEFAULT				
			--CASE WHEN @SortType = '' THEN E.ID END ASC 	
		)
		AS ROWNUMBER,
			RO.ID,
			RO.Nombre,
			RO.FechaRegistro,
			RO.FechaEliminado
		FROM [Seguridad].[Rol] RO
		--LEFT JOIN [Seguridad].[UsuarioRol] URO
		--ON URO.IdRol=RO.ID
		--LEFT JOIN [Seguridad].[Usuario] USU
		--ON USU.ID=URO.IdUsuario
		WHERE RO.Flag = @Flag AND RO.FlagBorrador = 0
		)
			SELECT
				ID,
				Nombre,
				FechaRegistro,
				FechaEliminado
			FROM Rol
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(RO.ID)
				FROM [Seguridad].[Rol] RO
				--LEFT JOIN [Seguridad].[UsuarioRol] URO
				--ON URO.IdRol=RO.ID
				--LEFT JOIN [Seguridad].[Usuario] USU
				--ON USU.ID=URO.IdUsuario
				WHERE RO.Flag = @Flag AND RO.FlagBorrador = 0
			)
END
