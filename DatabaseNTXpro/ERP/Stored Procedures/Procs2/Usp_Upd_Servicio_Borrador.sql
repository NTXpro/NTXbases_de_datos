
CREATE  PROC [ERP].[Usp_Upd_Servicio_Borrador]
@IdServicio	INT,
@Nombre			VARCHAR(50)
AS
BEGIN
		UPDATE [ERP].[Servicio]SET Nombre= @Nombre  WHERE ID=@IdServicio
END
