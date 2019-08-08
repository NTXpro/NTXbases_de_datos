
CREATE PROC [ERP].[Usp_Sel_Contrato_By_ID]
@IdContrato INT
AS
BEGIN
		SELECT CO.*,TC.*
		FROM ERP.Contrato CO
		INNER JOIN PLAME.T12TipoContrato TC ON TC.ID = CO.IdTipoContrato
		WHERE CO.ID = @IdContrato
END
