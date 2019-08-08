CREATE PROCEDURE [ERP].[Usp_Sel_Banco_Export]
@Flag bit
AS
BEGIN
SELECT             
				B.ID,
				EN.ID IdEntidad,
				EN.Nombre,
				B.FechaRegistro,
				B.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
			FROM [PLE].[T3Banco] B
		INNER JOIN ERP.Entidad EN
			ON EN.ID = B.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE B.Flag = @Flag AND B.FlagBorrador = 0
END
