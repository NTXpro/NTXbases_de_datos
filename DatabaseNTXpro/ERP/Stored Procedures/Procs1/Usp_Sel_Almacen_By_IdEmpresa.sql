
CREATE PROC [ERP].[Usp_Sel_Almacen_By_IdEmpresa]
@IdEmpresa INT
AS
BEGIN

	SELECT	A.ID,
			(A.Nombre + ' - ' + E.Direccion) AS Nombre,
			E.ID IdEstablecimiento,
			E.Nombre NombreEstablecimiento
		FROM ERP.Almacen A
		INNER JOIN ERP.Establecimiento E
			ON E.ID = A.IdEstablecimiento
		WHERE A.IdEmpresa = @IdEmpresa AND A.Flag = 1 AND A.FlagBorrador = 0

END
