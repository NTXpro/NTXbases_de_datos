CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoPagarDetalle_By_IdAplicacionAnticipoPagar]	
@IdAplicacionAnticipoPagar INT
AS
BEGIN
				SELECT AAPD.ID,
					   AAPD.Documento,
					   AAPD.Serie,
					   AAPD.Fecha,
					   AAPD.Total,
					   AAPD.TotalAplicado,
					   MO.CodigoSunat			Moneda,
					   TC.Nombre				TipoComprobante
				FROM ERP.AplicacionAnticipoPagarDetalle AAPD
				INNER JOIN ERP.AplicacionAnticipoPagar AAP
				ON AAP.ID = AAPD.IdAplicacionAnticipo
				INNER JOIN PLE.T10TipoComprobante TC
				ON TC.ID = AAPD.IdTipoComprobante
				INNER JOIN Maestro.Moneda MO
				ON MO.ID = AAPD.IdMoneda
				WHERE AAPD.IdAplicacionAnticipo = @IdAplicacionAnticipoPagar
END
