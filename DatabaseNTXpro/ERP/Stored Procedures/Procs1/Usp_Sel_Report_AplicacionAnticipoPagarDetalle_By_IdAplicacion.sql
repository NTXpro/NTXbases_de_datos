
CREATE PROC [ERP].[Usp_Sel_Report_AplicacionAnticipoPagarDetalle_By_IdAplicacion]
@IdAplicacionAnticipo INT
AS
BEGIN

		SELECT AAPD.Documento		Documento,
			   AAPD.Serie			Serie,
			   AAPD.Total			Total,
			   AAPD.TotalAplicado	TotalAplicado,
			   TC.Nombre			TipoComprobante,
			   MO.CodigoSunat		Moneda
		FROM ERP.AplicacionAnticipoPagarDetalle AAPD
		INNER JOIN ERP.AplicacionAnticipoPagar AAP
		ON AAP.ID = AAPD.IdAplicacionAnticipo
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = AAPD.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO 
		ON MO.ID = AAPD.IdMoneda
		WHERE AAPD.IdAplicacionAnticipo = @IdAplicacionAnticipo
END
