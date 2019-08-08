create PROCEDURE [ERP].[Usp_Sel_TipoDocumento_By_NumeroDocumento]
@NumeroDocumento VARCHAR(250)
AS
BEGIN

	SELECT 
		   ET.NumeroDocumento
	FROM ERP.EntidadTipoDocumento ET INNER JOIN ERP.Entidad E
		ON ET.IdEntidad = E.ID
	INNER JOIN [PLE].[T2TipoDocumento] TD
		ON TD.ID = ET.IdTipoDocumento
	WHERE ET.NumeroDocumento = @NumeroDocumento AND E.Flag = 1 AND E.FlagBorrador = 0

END