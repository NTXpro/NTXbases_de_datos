
create PROC [ERP].[Usp_Sel_Report_AplicacionAnticipoCobrarDetalle_By_IdAplicacionAnticipoCobrar]
@IdAplicacionAnticipoCobrar INT
AS
BEGIN
		SELECT			AACD.ID,
						AACD.Documento,
						AACD.Serie,
						AACD.Fecha,
						AACD.Total,
						AACD.TotalAplicado,
						MO.CodigoSunat			Moneda,
						TC.Nombre				TipoComprobante
		FROM ERP.AplicacionAnticipoCobrarDetalle AACD
		INNER JOIN ERP.AplicacionAnticipoCobrar AAC
		ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = AACD.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = AACD.IdMoneda
		WHERE AACD.IdAplicacionAnticipoCobrar = @IdAplicacionAnticipoCobrar
END
