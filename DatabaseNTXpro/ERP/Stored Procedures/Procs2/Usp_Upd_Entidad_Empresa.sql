CREATE PROC [ERP].[Usp_Upd_Entidad_Empresa]
@IdEmpresa int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	UPDATE ERP.Empresa SET IdEntidad = @NewIdEntidad where ID = @IdEmpresa

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END