CREATE PROC [ERP].[Usp_Sel_Transporte] 
@IdEmpresa INT
AS
BEGIN
		SELECT TR.ID,
			   ENT.Nombre 
		FROM ERP.Transporte TR
		INNER JOIN ERP.Entidad ENT ON ENT.ID = TR.IdEntidad
		WHERE TR.FlagBorrador = 0 AND TR.IdEmpresa = @IdEmpresa AND TR.Flag = 1
END
