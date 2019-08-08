
create PROC [ERP].[Usp_Sel_Almacen_By_IdEstablecimiento]
@IdEstablecimiento INT
AS
BEGIN

	SELECT	A.ID,
			(A.Nombre + ' - ' + E.Direccion) AS Nombre,
			E.ID IdEstablecimiento,
			E.Nombre NombreEstablecimiento
		FROM ERP.Almacen A
		INNER JOIN ERP.Establecimiento E
			ON E.ID = A.IdEstablecimiento
		WHERE A.IdEstablecimiento = @IdEstablecimiento
		AND A.Flag = 1 AND A.FlagBorrador = 0
END
