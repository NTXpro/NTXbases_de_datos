CREATE PROC [ERP].[Usp_Sel_CuentaPagar_By_ID]-- 4
@Id INT
AS
BEGIN
	

	SELECT	CP.ID,
			IdEntidad,
			Serie,
			Numero,
			TipoCambio,
			CP.Total AS SaldoInicialSoles,
			(CP.Total - (SELECT [ERP].[ObtenerTotalMovimientoCuentaPagar](CP.ID))) AS SaldoSoles ,
			(CP.Total/CP.TipoCambio) AS SaldoInicialDolares,
			(CP.Total/CP.TipoCambio) AS SaldoDolares,
			IdTipoComprobante,
			TC.Nombre TipoComprobante,
			E.Nombre NombreEntidad
	FROM ERP.CuentaPagar CP
	INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = CP.IdTipoComprobante
	INNER JOIN ERP.Entidad E ON E.ID = CP.IdEntidad
	WHERE CP.ID = @Id
END
