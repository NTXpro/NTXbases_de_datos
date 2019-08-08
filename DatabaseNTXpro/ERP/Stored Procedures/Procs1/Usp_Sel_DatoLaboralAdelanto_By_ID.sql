
CREATE PROC [ERP].[Usp_Sel_DatoLaboralAdelanto_By_ID]
@IdAdelanto INT
AS
BEGIN
		SELECT * 
		FROM ERP.DatoLaboralAdelanto
		WHERE ID = @IdAdelanto
END
