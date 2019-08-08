CREATE PROC [ERP].[Usp_Sel_Contrato]
@IdDatoLaboral INT,
@IdEmpresa INT
AS
BEGIN
		SELECT CO.* ,TC.*
		FROM ERP.Contrato CO
		INNER JOIN PLAME.T12TipoContrato TC ON TC.ID = CO.IdTipoContrato
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = CO.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = CO.IdEmpresa
		WHERE CO.IdDatoLaboral = @IdDatoLaboral AND EM.ID = @IdEmpresa
END
