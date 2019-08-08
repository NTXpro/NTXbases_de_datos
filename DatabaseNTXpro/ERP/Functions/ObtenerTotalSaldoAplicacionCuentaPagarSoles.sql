CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaPagarSoles](
@IdCuentaPagar INT
)
RETURNS DECIMAL(14,6)
AS
BEGIN

		DECLARE @TotalCuentaPagar DECIMAL(14,6) ;
		DECLARE @TotalAplicacionPagarDetalle DECIMAL(14,6);
		DECLARE @Saldo DECIMAL(14,6);
		
		
		SET @TotalCuentaPagar= (SELECT CP.Total FROM ERP.CuentaPagar CP WHERE ID = @IdCuentaPagar)


		SET @TotalAplicacionPagarDetalle = (SELECT SUM(AAPD.TotalAplicado)
													FROM ERP.AplicacionAnticipoPagarDetalle AAPD
													INNER JOIN ERP.AplicacionAnticipoPagar AAP 
													ON AAPD.IdAplicacionAnticipo = AAP.ID
													INNER JOIN ERP.CuentaPagar CP
													ON CP.ID = AAP.IdCuentaPagar
													WHERE AAP.IdCuentaPagar = @IdCuentaPagar)

		SET @Saldo = ISNULL(@TotalCuentaPagar,0)-ISNULL(@TotalAplicacionPagarDetalle,0)

		RETURN ISNULL(@Saldo,0)
END
