
CREATE PROC ERP.Usp_Upd_Requerimiento_Anular
@ID int
AS
BEGIN
	UPDATE ERP.Requerimiento SET IdRequerimientoEstado = 2 WHERE ID = @ID
END
