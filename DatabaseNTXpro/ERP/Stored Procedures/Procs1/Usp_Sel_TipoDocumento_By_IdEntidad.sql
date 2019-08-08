CREATE PROCEDURE [ERP].[Usp_Sel_TipoDocumento_By_IdEntidad]
@IdEntidad INT
AS
BEGIN

	SELECT ET.ID,
		   E.ID IdEntidad,
		   ET.IdTipoDocumento,
		   TD.Abreviatura NombreTipoDocumento,
		   ET.NumeroDocumento
	FROM ERP.EntidadTipoDocumento ET INNER JOIN ERP.Entidad E
		ON ET.IdEntidad = E.ID
	INNER JOIN [PLE].[T2TipoDocumento] TD
		ON TD.ID = ET.IdTipoDocumento
	WHERE E.ID = @IdEntidad AND E.Flag = 1 AND E.FlagBorrador = 0

END