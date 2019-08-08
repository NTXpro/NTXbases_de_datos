CREATE PROC [ERP].[Usp_Sel_Servicio_Pagination] 
@IdEmpresa INT,
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Servicio AS
	(
		SELECT ROW_NUMBER() OVER
		(ORDER BY
			--ASC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'ASC') THEN SER.ID END ASC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'ASC') THEN SER.Nombre END ASC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN SER.FechaRegistro END ASC,
			CASE WHEN(@SortType = 'UnidadMedida' AND @SortDir = 'ASC') THEN T6U.CodigoSunat END ASC,
		
			--DESC
			CASE WHEN(@SortType = 'ID' AND @SortDir = 'DESC') THEN SER.ID END DESC,
			CASE WHEN(@SortType = 'Nombre' AND @SortDir = 'DESC') THEN SER.Nombre END DESC,
			CASE WHEN(@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN SER.FechaRegistro END DESC,
			CASE WHEN(@SortType = 'UnidadMedida' AND @SortDir = 'DESC') THEN T6U.CodigoSunat END DESC

			--DEFAULT				
			--CASE WHEN @SortType = '' THEN E.ID END ASC 	
		)
		AS ROWNUMBER,
			SER.ID,
			SER.Nombre,
			T6U.CodigoSunat AS 'UnidadMedida',
			T5E.CodigoSunat AS 'CodigoExistencia',
			SER.FechaRegistro,
			SER.FechaEliminado,
			PL.CuentaContable,
			PL.Nombre		AS  'NombrePlanCuenta'
		FROM [ERP].[Producto] SER
		LEFT JOIN PLE.T6UnidadMedida T6U
		ON SER.IdUnidadMedida=T6U.ID
		LEFT JOIN Maestro.Marca MA
		ON SER.IdMarca = MA.ID
		LEFT JOIN [ERP].[PlanCuenta] PL
		ON PL.ID = SER.IdPlanCuenta
		LEFT JOIN PLE.T5Existencia T5E
		ON SER.IdExistencia  = T5E.ID
		LEFT JOIN Maestro.TipoProducto TP
		ON SER.IdTipoProducto=TP.ID
		WHERE SER.Flag = @Flag AND SER.FlagBorrador = 0 AND SER.IdTipoProducto = 2 AND SER.IdEmpresa = @IdEmpresa
		)
			SELECT
				ID,
				Nombre,
				FechaRegistro,
				UnidadMedida,
				CodigoExistencia,
				FechaEliminado,
				NombrePlanCuenta
			FROM Servicio
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page -1) +1) AND @Page * @RowsPerPage

			SET @RowCount=(
				SELECT	COUNT(SER.ID)
				FROM [ERP].[Producto] SER
				LEFT JOIN PLE.T6UnidadMedida T6U
				ON SER.IdUnidadMedida=T6U.ID
				LEFT JOIN Maestro.Marca MA
				ON SER.IdMarca = MA.ID
				LEFT JOIN [ERP].[PlanCuenta] PL
				ON PL.ID = SER.IdPlanCuenta
				LEFT JOIN PLE.T5Existencia T5E
				ON SER.IdExistencia  = T5E.ID
				LEFT JOIN Maestro.TipoProducto TP
				ON SER.IdTipoProducto=TP.ID
				WHERE SER.Flag = @Flag AND SER.FlagBorrador = 0 AND SER.IdTipoProducto = 2 AND SER.IdEmpresa = @IdEmpresa
			)
END
