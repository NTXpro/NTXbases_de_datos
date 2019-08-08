CREATE PROC [ERP].[Usp_Upd_Entidad_Proveedor]
@IdProveedor int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	UPDATE ERP.Proveedor SET IdEntidad = @NewIdEntidad where ID = @IdProveedor

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END