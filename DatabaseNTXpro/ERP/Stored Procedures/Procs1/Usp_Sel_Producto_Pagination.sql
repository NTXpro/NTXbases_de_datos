CREATE PROC [ERP].[Usp_Sel_Producto_Pagination] 
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@IdEmpresa INT ,
@RowCount INT OUT
AS
BEGIN

	WITH Producto AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN PRO.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN PRO.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN PRO.FechaRegistro END ASC,
			CASE WHEN(@SortType = 'UnidadMedida' AND @SortDir = 'ASC') THEN T6U.CodigoSunat END ASC,
		
			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN PRO.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN PRO.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN PRO.FechaRegistro END DESC,
			CASE WHEN(@SortType = 'UnidadMedida' AND @SortDir = 'DESC') THEN T6U.CodigoSunat END DESC

			--DEFAULT				
			--CASE WHEN @SortType = '' THEN E.ID END ASC 	
		)
		AS ROWNUMBER,
			PRO.ID,
			PRO.Nombre,
			T6U.CodigoSunat		UnidadMedida,
			T5E.CodigoSunat		CodigoExistencia,
			PRO.FechaRegistro,
			T6U.Nombre          NombreUnidadMedida,
			PRO.FechaEliminado
		FROM [ERP].[Producto] PRO
		LEFT JOIN PLE.T6UnidadMedida T6U
		ON PRO.IdUnidadMedida=T6U.ID
		LEFT JOIN Maestro.Marca MA
		ON PRO.IdMarca = MA.ID
		LEFT JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia  = T5E.ID
		LEFT JOIN Maestro.TipoProducto TP
		ON PRO.IdTipoProducto=TP.ID
		LEFT JOIN ERP.Empresa EM
		ON EM.ID=PRO.IdEmpresa
		WHERE PRO.Flag = @Flag AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa=@IdEmpresa AND PRO.IdTipoProducto= 1
		)
			SELECT
				ID,
				Nombre,
				FechaRegistro,
				UnidadMedida,
				CodigoExistencia,
				NombreUnidadMedida,
				FechaEliminado
			FROM Producto
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(PRO.ID)
				FROM [ERP].[Producto] PRO
				LEFT JOIN PLE.T6UnidadMedida T6U
				ON PRO.IdUnidadMedida=T6U.ID
				LEFT JOIN Maestro.Marca MA
				ON PRO.IdMarca = MA.ID
				LEFT JOIN PLE.T5Existencia T5E
				ON PRO.IdExistencia  = T5E.ID
				LEFT JOIN Maestro.TipoProducto TP
				ON PRO.IdTipoProducto=TP.ID
				WHERE PRO.Flag = @Flag AND PRO.FlagBorrador = 0 AND PRO.IdTipoProducto= 1
			)
END