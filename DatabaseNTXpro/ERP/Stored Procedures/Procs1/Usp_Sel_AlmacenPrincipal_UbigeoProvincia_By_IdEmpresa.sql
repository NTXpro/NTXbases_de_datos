CREATE PROC [ERP].[Usp_Sel_AlmacenPrincipal_UbigeoProvincia_By_IdEmpresa]
@IdEmpresa INT
AS
BEGIN

	SELECT
		T7PR.ID,
		T7PR.Nombre
	FROM ERP.Almacen A
	INNER JOIN ERP.Establecimiento E ON E.ID = A.IdEstablecimiento
	INNER JOIN PLAME.T7Ubigeo T7 ON T7.ID = E.IdUbigeo
	INNER JOIN PLAME.T7Ubigeo T7PR ON CONCAT('00', LEFT(T7.CodigoSunat, 4)) = T7PR.CodigoSunat
	WHERE A.FlagBorrador = 0 AND A.Flag = 1
	AND A.IdEmpresa = @IdEmpresa AND A.FlagPrincipal = 1
	
END