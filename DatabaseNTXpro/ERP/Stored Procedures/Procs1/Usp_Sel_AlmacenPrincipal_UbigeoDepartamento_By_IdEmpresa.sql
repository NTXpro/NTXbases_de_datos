CREATE PROC [ERP].[Usp_Sel_AlmacenPrincipal_UbigeoDepartamento_By_IdEmpresa]
@IdEmpresa INT
AS
BEGIN

	SELECT
		T7DE.ID,
		T7DE.Nombre
	FROM ERP.Almacen A
	INNER JOIN ERP.Establecimiento E ON E.ID = A.IdEstablecimiento
	INNER JOIN PLAME.T7Ubigeo T7 ON T7.ID = E.IdUbigeo
	INNER JOIN PLAME.T7Ubigeo T7DE ON CONCAT('0000', LEFT(T7.CodigoSunat, 2)) = T7DE.CodigoSunat
	WHERE A.FlagBorrador = 0 AND A.Flag = 1
	AND A.IdEmpresa = @IdEmpresa AND A.FlagPrincipal = 1
	
END