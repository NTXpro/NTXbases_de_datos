CREATE PROC [ERP].[Usp_Sel_TrabajadorImagen_By_ID]
@ID INT
AS
BEGIN
	SELECT
		Imagen
	FROM ERP.Trabajador
	WHERE ID = @ID
END
