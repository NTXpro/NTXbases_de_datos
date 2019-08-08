
CREATE PROC [ERP].[Usp_Upd_Entidad_Cliente]
@IdCliente int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	UPDATE ERP.Cliente SET IdEntidad = @NewIdEntidad where ID = @IdCliente

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END