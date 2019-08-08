CREATE PROC [ERP].[Usp_Sel_SCTR] 
@IdDatoLaboral INT,
@IdEmpresa INT
AS
BEGIN
		SELECT SC.* ,
			   PE.*,
			   SA.*
		FROM ERP.SCTR SC 
		INNER JOIN Maestro.TipoPension PE ON PE.ID = SC.IdTipoPension
		INNER JOIN Maestro.TipoSalud SA ON SA.ID = SC.IdTipoSalud
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = SC.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = SC.IdEmpresa 
		WHERE DL.ID = @IdDatoLaboral AND EM.ID = @IdEmpresa
END
