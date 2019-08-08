CREATE PROC [ERP].[Usp_Sel_Vendedor_By_ID]
@IdVendedor INT
AS
BEGIN
		SELECT
				V.ID,
				V.UsuarioActivo,
				V.UsuarioElimino,
				V.UsuarioModifico,
				V.UsuarioRegistro,
				V.FechaActivacion,
				V.FechaEliminado,
				V.FechaModificado,
				EN.FechaRegistro,
				T.IdEntidad,
				T.ID IdTrabajador,
				P.Nombre,
				P.ApellidoPaterno,
				P.ApellidoMaterno,
				ETD.NumeroDocumento,
				ETD.IdTipoDocumento,
				TD.Abreviatura
		FROM ERP.Vendedor V
		INNER JOIN ERP.Trabajador T
			ON T.ID = V.IdTrabajador
		INNER JOIN ERP.Entidad EN
			ON EN.ID = T.IdEntidad
		INNER JOIN ERP.Persona P
			ON P.IdEntidad = EN.ID
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN [PLE].[T2TipoDocumento] TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE V.ID = @IdVendedor
END
