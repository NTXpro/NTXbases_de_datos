CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaPagarDetalleSoles](
@IdCuentaPagar INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @TotalCuentaPagar DECIMAL(15,6);
		DECLARE @TotalAplicacionPagarDetalle DECIMAL(15,6);
		DECLARE @Saldo DECIMAL(14,6);

		SET @TotalCuentaPagar = (SELECT CP.Total FROM ERP.CuentaPagar CP WHERE ID = @IdCuentaPagar)
		SET @TotalAplicacionPagarDetalle = (SELECT SUM(IIF(CP.IdMoneda = 2,AAPD.TotalAplicado/AAP.TipoCambio,IIF(CP.IdMoneda = 1,ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2),AAPD.TotalAplicado)))
												FROM ERP.AplicacionAnticipoPagarDetalle AAPD
												INNER JOIN ERP.AplicacionAnticipoPagar AAP
												ON AAP.ID = AAPD.IdAplicacionAnticipo
												INNER JOIN ERP.CuentaPagar CP
												ON CP.ID = AAPD.IdCuentaPagar
												WHERE AAPD.IdCuentaPagar = @IdCuentaPagar)

		SET @Saldo = ISNULL(@TotalCuentaPagar,0) - ISNULL(@TotalAplicacionPagarDetalle,0)

		RETURN ISNULL(@Saldo,0)
		
END
