CREATE PROC ERP.Usp_Del_SaldoInicialCobrar_Borrador
@IdSaldo INT
AS
BEGIN

		DELETE ERP.SaldoInicialCobrar WHERE ID = @IdSaldo

END
