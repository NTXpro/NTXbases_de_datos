CREATE PROC [ERP].[Usp_Sel_Almacen_By_ID]
@IdAlmacen INT
AS
BEGIN

	SELECT	A.ID,
			A.Nombre,
			A.UsuarioRegistro,
			A.UsuarioModifico,
			A.UsuarioElimino,
			A.UsuarioActivo,
			A.FechaRegistro,
			A.FechaModificado,
			A.FechaEliminado,
			A.FechaActivacion,
			E.ID IdEstablecimiento,
			E.Nombre + ' - '+ E.Direccion NombreEstablecimiento,
			A.FlagPrincipal
		FROM ERP.Almacen A
		INNER JOIN ERP.Establecimiento E
			ON E.ID = A.IdEstablecimiento
		WHERE A.ID = @IdAlmacen

END