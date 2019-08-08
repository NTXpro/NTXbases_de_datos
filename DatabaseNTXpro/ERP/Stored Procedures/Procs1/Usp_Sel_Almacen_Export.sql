CREATE PROCEDURE [ERP].[Usp_Sel_Almacen_Export]
@Flag bit,
@IdEmpresa int
AS
BEGIN 
SELECT 
			A.ID,
				A.Nombre,
				E.ID IdEstablecimiento,
				E.Nombre NombreEstablecimiento,
				E.Direccion,
				A.FechaRegistro
			FROM ERP.Almacen A
			INNER JOIN ERP.Establecimiento E
				ON E.ID = A.IdEstablecimiento
			WHERE A.Flag = @Flag AND A.IdEmpresa = @IdEmpresa AND A.FlagBorrador = 0
END
