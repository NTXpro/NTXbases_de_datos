CREATE PROC [ERP].[Usp_Upd_Rol_Borrador]
@IdRol	INT,
@Nombre			VARCHAR(50)
AS
BEGIN
		UPDATE [Seguridad].[Rol] SET Nombre= @Nombre  WHERE ID=@IdRol
END