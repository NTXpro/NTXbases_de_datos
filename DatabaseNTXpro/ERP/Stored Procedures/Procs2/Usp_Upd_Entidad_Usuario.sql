
CREATE PROC [ERP].[Usp_Upd_Entidad_Usuario]
@IdUsuario int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	UPDATE Seguridad.Usuario SET IdEntidad = @NewIdEntidad where ID = @IdUsuario

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END