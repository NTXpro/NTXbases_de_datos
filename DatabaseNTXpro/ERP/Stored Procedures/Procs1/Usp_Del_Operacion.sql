CREATE PROC ERP.Usp_Del_Operacion
@IdOperacion INT
AS
BEGIN

		DELETE ERP.Operacion WHERE ID = @IdOperacion
END
