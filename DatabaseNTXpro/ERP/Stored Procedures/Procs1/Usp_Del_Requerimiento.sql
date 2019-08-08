

CREATE PROC ERP.Usp_Del_Requerimiento
@ID int
AS
BEGIN
	DELETE FROM ERP.RequerimientoReferencia WHERE IdRequerimiento = @ID
	DELETE FROM ERP.RequerimientoDetalle WHERE IdRequerimiento = @ID
	DELETE FROM ERP.Requerimiento WHERE ID = @ID
END
