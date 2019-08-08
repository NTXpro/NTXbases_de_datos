
CREATE PROC [ERP].[Usp_Sel_ListaPrecio_By_ID]
@ID INT
AS
BEGIN
	
	SELECT	LP.ID,
			LP.NOMBRE,
			IdMoneda,
			M.Nombre NombreMoneda,
			PorcentajeDescuento,
			FechaRegistro,
			UsuarioRegistro,
			FechaModificado,
			UsuarioModifico,
			FechaEliminado,
			UsuarioElimino,
			FechaActivacion,
			UsuarioActivo
	FROM ERP.ListaPrecio LP INNER JOIN Maestro.Moneda M
		ON M.ID = LP.IdMoneda
	WHERE LP.ID = @Id

END