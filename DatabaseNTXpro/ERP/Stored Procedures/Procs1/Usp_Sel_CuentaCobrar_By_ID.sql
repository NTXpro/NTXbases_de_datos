CREATE PROC [ERP].[Usp_Sel_CuentaCobrar_By_ID]
@Id INT
AS
BEGIN
	
	SELECT	CC.ID,
			IdEntidad,
			Serie,
			Numero,
			TipoCambio,
			CC.Total AS SaldoInicialSoles,
			(CC.Total) AS SaldoSoles ,
			(CC.Total/CC.TipoCambio) AS SaldoInicialDolares,
			(CC.Total/CC.TipoCambio) AS SaldoDolares,
			IdTipoComprobante,
			TC.Nombre TipoComprobante,
			E.Nombre NombreEntidad
	FROM ERP.CuentaCobrar CC
	INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = CC.IdTipoComprobante
	INNER JOIN ERP.Entidad E ON E.ID = CC.IdEntidad
	WHERE CC.ID = @Id
END
