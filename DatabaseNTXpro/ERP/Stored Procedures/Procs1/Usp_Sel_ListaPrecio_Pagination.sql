
CREATE PROC [ERP].[Usp_Sel_ListaPrecio_Pagination]
@IdEmpresa INT,
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH ListaPrecio AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN LTRIM(LP.Nombre) END ASC,
				CASE WHEN (@SortType = 'PorcentajeDescuento' AND @SortDir = 'ASC') THEN LP.PorcentajeDescuento END ASC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'ASC') THEN LP.FechaRegistro END ASC,
				--DESC
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN LTRIM(LP.Nombre) END DESC,
				CASE WHEN (@SortType = 'PorcentajeDescuento' AND @SortDir = 'DESC') THEN LP.PorcentajeDescuento END DESC,
				CASE WHEN (@SortType = 'FechaRegistro' AND @SortDir = 'DESC') THEN LP.FechaRegistro END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				LP.ID,
				LP.Nombre,
				LP.PorcentajeDescuento,
				LP.FechaRegistro,
				LP.FlagPrincipal
		FROM ERP.ListaPrecio LP
		WHERE LP.Flag = @Flag AND LP.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa
		)
		SELECT 
			ID,
			Nombre,
			PorcentajeDescuento,
			FechaRegistro,
			FlagPrincipal
		FROM ListaPrecio
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(LP.ID)
			FROM ERP.ListaPrecio LP
			WHERE LP.Flag = @Flag AND LP.FlagBorrador = 0 AND IdEmpresa = @IdEmpresa
		)	

END

