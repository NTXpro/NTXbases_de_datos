

CREATE PROC ERP.Usp_Del_SaldoInicial_Borrador
@IdSaldo INT
AS
BEGIN

		DELETE ERP.SaldoInicial WHERE ID = @IdSaldo

END