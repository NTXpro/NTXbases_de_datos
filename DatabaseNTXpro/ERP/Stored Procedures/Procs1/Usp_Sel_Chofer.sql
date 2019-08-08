
CREATE PROC [ERP].[Usp_Sel_Chofer]
@IdEmpresa INT
AS
BEGIN
		SELECT CH.ID,
			   ENT.Nombre
		FROM ERP.Chofer CH
		INNER JOIN ERP.Entidad ENT ON ENT.ID = CH.IdEntidad
		WHERE CH.FlagBorrador = 0 AND CH.IdEmpresa = @IdEmpresa AND CH.Flag = 1
END
