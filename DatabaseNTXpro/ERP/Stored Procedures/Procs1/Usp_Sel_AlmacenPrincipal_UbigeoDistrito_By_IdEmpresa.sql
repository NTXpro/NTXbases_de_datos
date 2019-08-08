CREATE PROC [ERP].[Usp_Sel_AlmacenPrincipal_UbigeoDistrito_By_IdEmpresa]
@IdEmpresa INT
AS
BEGIN

	SELECT
		T7.ID,
		T7.Nombre
	FROM ERP.Almacen A
	INNER JOIN ERP.Establecimiento E ON E.ID = A.IdEstablecimiento
	INNER JOIN PLAME.T7Ubigeo T7 ON T7.ID = E.IdUbigeo
	WHERE A.FlagBorrador = 0 AND A.Flag = 1
	AND A.IdEmpresa = @IdEmpresa AND A.FlagPrincipal = 1
	
END