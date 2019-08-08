CREATE PROCEDURE [ERP].[Usp_Sel_Ubicacion_By_ID] --1
@IdUbicacion INT
AS
BEGIN
	SELECT 
		U.ID,
		U.Codigo,
		U.Nombre,
		U.IdAlmacen,
		U.UsuarioRegistro,
		U.FechaRegistro,
		U.UsuarioModifico,
		U.FechaModificado,
		U.UsuarioElimino,
		U.FechaEliminado,
		U.UsuarioActivo,
		U.FechaActivacion,
		U.FlagBorrador,
		U.Flag,
		A.Nombre As NombreAlmacen
	FROM ERP.Ubicacion U
	INNER JOIN ERP.Almacen A ON U.IdAlmacen = A.ID
	INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
    WHERE
    U.ID = @IdUbicacion
END