
CREATE PROC [ERP].[Usp_Sel_DatoLaboralPrestamo_By_ID]
@IdPrestamo INT
AS
BEGIN
		SELECT PRE.*,CO.*
		FROM ERP.DatoLaboralPrestamo PRE
		INNER JOIN ERP.Concepto CO ON CO.ID = PRE.IdConcepto
		WHERE PRE.ID = @IdPrestamo
END
