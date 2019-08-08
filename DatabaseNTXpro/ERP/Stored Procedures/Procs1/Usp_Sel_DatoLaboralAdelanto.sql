
CREATE PROC [ERP].[Usp_Sel_DatoLaboralAdelanto] 
@IdDatoLaboral INT,
@IdEmpresa INT
AS
BEGIN
		SELECT AD.*
		FROM ERP.DatoLaboralAdelanto AD
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = AD.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = AD.IdEmpresa 
		WHERE DL.ID = @IdDatoLaboral AND EM.ID = @IdEmpresa
END
