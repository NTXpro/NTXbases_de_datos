CREATE PROCEDURE [ERP].[Usp_Sel_Cliente_Export]
@Flag bit,
@IdEmpresa int
AS
BEGIN
SELECT
                C.ID,
				EN.Nombre,
				C.FechaRegistro,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Cliente C
		INNER JOIN ERP.Entidad EN
			ON EN.ID = C.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE C.Flag = @Flag AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa
END