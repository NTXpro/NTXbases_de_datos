CREATE PROC [ERP].[Usp_Sel_AlmacenPrincipal_Direccion_By_IdEmpresa]
@IdEmpresa INT
AS
BEGIN

	SELECT
		--E.ID,
		--E.IdEntidad,
		E.Direccion
	FROM ERP.Almacen A
	INNER JOIN ERP.Establecimiento E ON E.ID = A.IdEstablecimiento
	WHERE A.FlagBorrador = 0 AND A.Flag = 1
	AND A.IdEmpresa = @IdEmpresa AND A.FlagPrincipal = 1
	
END