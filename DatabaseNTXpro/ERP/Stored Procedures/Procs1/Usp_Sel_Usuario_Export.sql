CREATE PROCEDURE [ERP].[Usp_Sel_Usuario_Export]
@Flag bit
AS
BEGIN
SELECT
                U.ID,
				EN.Nombre,
				U.Correo,
				U.FechaRegistro,
				U.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM Seguridad.Usuario U
		INNER JOIN ERP.Entidad EN
			ON EN.ID = U.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE U.Flag = @Flag AND U.FlagBorrador = 0
END
