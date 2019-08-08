

CREATE PROC [ERP].[Usp_Sel_Proveedor_Inactivo]
@IdEmpresa INT
AS
BEGIN

		SELECT	P.ID,
				EN.ID IdEntidad,
				EN.Nombre,
				P.FechaRegistro,
				P.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Proveedor P
		INNER JOIN ERP.Entidad EN
			ON EN.ID = P.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE P.FlagBorrador = 0 AND P.IdEmpresa = @IdEmpresa AND P.Flag = 0

END

