
create PROC [ERP].[Usp_Upd_Entidad_Trabajador]
@IdTrabajador int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	UPDATE ERP.Trabajador SET IdEntidad = @NewIdEntidad where ID = @IdTrabajador

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END
