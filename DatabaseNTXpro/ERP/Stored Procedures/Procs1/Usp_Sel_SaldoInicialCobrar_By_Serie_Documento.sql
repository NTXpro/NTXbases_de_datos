
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROC [ERP].[Usp_Sel_SaldoInicialCobrar_By_Serie_Documento]
@IdEmpresa INT,
@IdTipoComprobante INT,
@Serie VARCHAR(4),
@Documento VARCHAR(8)
AS
BEGIN
	SELECT	SIC.ID,
			SIC.IdCliente,
			SIC.Monto,
			TC.Nombre NombreTipoComprobante
	FROM [ERP].[SaldoInicialCobrar] SIC
	INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = SIC.IdTipoComprobante
	WHERE SIC.IdTipoComprobante = @IdTipoComprobante AND SIC.Serie = @Serie AND SIC.Documento = @Documento AND SIC.IdEmpresa = @IdEmpresa
	AND SIC.Flag = 1
END
