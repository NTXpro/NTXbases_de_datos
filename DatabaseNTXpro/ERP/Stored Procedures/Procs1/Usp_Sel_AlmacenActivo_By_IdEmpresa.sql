CREATE PROC [ERP].[Usp_Sel_AlmacenActivo_By_IdEmpresa]
@IdEmpresa INT
AS
BEGIN

	SELECT A.ID,
		A.Nombre,
		E.ID IdEstablecimiento,
		E.Nombre NombreEstablecimiento,
		E.Direccion,
		A.FechaRegistro
	FROM ERP.Almacen A
	INNER JOIN ERP.Establecimiento E ON E.ID = A.IdEstablecimiento
	WHERE A.IdEmpresa = @IdEmpresa AND A.FlagBorrador = 0 AND A.Flag = 1
END
