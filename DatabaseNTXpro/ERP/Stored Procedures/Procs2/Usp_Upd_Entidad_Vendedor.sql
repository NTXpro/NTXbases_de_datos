
create PROC [ERP].[Usp_Upd_Entidad_Vendedor]
@IdVendedor int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	DECLARE @IdTrabajador INT= (SELECT IdTrabajador FROM ERP.Vendedor WHERE ID = @IdVendedor)

	UPDATE ERP.Trabajador SET IdEntidad = @NewIdEntidad where ID = @IdTrabajador

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END