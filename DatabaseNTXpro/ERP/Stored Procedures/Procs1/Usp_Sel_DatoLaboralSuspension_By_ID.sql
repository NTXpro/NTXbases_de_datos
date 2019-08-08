
create PROC [ERP].[Usp_Sel_DatoLaboralSuspension_By_ID]
@IdSuspension INT
AS
BEGIN
		SELECT SU.*,TS.*
		FROM ERP.DatoLaboralSuspension SU
		INNER JOIN PLAME.T21TipoSuspension TS ON TS.ID = SU.IdTipoSuspension
		WHERE SU.ID = @IdSuspension
END
