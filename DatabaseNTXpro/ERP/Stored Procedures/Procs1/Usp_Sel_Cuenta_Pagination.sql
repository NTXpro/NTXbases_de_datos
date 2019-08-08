CREATE PROC [ERP].[Usp_Sel_Cuenta_Pagination] --3,1,1,10,'','',10
@IdEmpresa INT,
@Flag BIT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

	WITH Empresa AS
	(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN C.Nombre END ASC,
				CASE WHEN (@SortType = 'Banco' AND @SortDir = 'ASC') THEN E.Nombre END ASC,
				CASE WHEN (@SortType = 'CuentaContable' AND @SortDir = 'ASC') THEN PC.CuentaContable END ASC,
				CASE WHEN (@SortType = 'NombrePlanCuenta' AND @SortDir = 'ASC') THEN PC.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN C.Nombre END DESC,
				CASE WHEN (@SortType = 'NumeroDocumento' AND @SortDir = 'DESC') THEN E.Nombre END DESC,
				CASE WHEN (@SortType = 'CuentaContable' AND @SortDir = 'DESC') THEN PC.CuentaContable END DESC,
				CASE WHEN (@SortType = 'NombrePlanCuenta' AND @SortDir = 'DESC') THEN PC.Nombre END DESC
				--DEFAULT				
				--CASE WHEN @SortType = '' THEN E.ID END ASC 				
			)	
			AS ROWNUMBER,
				C.ID,
				C.Nombre,
				E.Nombre AS NombreBanco,
				PC.CuentaContable,
				PC.Nombre AS NombrePlanCuenta
		FROM ERP.Cuenta C INNER JOIN PLE.T3Banco B
			ON B.ID = C.IdBanco
		INNER JOIN ERP.Entidad E
			ON E.ID = B.IdEntidad
		INNER JOIN ERP.PlanCuenta PC
			ON PC.ID = C.IdPlanCuenta
		WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa
		)
		SELECT 
			ID,
			Nombre,
			NombreBanco,
			CuentaContable,
			NombrePlanCuenta
		FROM Empresa
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(E.ID)
			FROM ERP.Cuenta C INNER JOIN PLE.T3Banco B
			ON B.ID = C.IdBanco
			INNER JOIN ERP.Entidad E
				ON E.ID = B.IdEntidad
			INNER JOIN ERP.PlanCuenta PC
				ON PC.ID = C.IdPlanCuenta
			WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa
		)	 

END



