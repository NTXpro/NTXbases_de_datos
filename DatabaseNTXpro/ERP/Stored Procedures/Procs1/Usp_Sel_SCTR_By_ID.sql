CREATE PROC [ERP].[Usp_Sel_SCTR_By_ID]
@IdSctr INT
AS
BEGIN
		SELECT SC.* ,
			   PE.*,
			   SA.*
		FROM ERP.SCTR SC 
		INNER JOIN Maestro.TipoPension PE ON PE.ID = SC.IdTipoPension
		INNER JOIN Maestro.TipoSalud SA ON SA.ID = SC.IdTipoSalud
		WHERE SC.ID = @IdSctr
END
