
CREATE PROC [ERP].[Usp_Sel_UltimaFechaCTS_By_DatoLaboral]
@IdDatoLaboral INT
AS
BEGIN
	DECLARE @FechaFinCTS DATETIME = (SELECT TOP 1 MAX(CTS.FechaFin) FROM ERP.CTS CTS
											INNER JOIN ERP.CTSDetalle CTSD ON CTSD.IdCTS = CTS.ID
											WHERE CTSD.IdDatoLaboral = @IdDatoLaboral);
	SELECT @FechaFinCTS;
END
