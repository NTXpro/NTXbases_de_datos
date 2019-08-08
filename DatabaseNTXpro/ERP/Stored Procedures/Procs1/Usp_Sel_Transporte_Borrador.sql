
CREATE PROC ERP.Usp_Sel_Transporte_Borrador
@IdEmpresa INT
AS
BEGIN

	SELECT  TR.ID,
			EN.Nombre,
			TR.FechaRegistro,
			TR.FechaEliminado,
			ETD.NumeroDocumento,
			TD.Nombre AS NombreTipoDocumento
	FROM ERP.Transporte TR
	INNER JOIN ERP.Entidad EN
	ON EN.ID = TR.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
	ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
	ON TD.ID = ETD.IdTipoDocumento
	WHERE TR.FlagBorrador = 1 AND TR.IdEmpresa = @IdEmpresa

END
