CREATE PROC [ERP].[Usp_Upd_Entidad_Banco]
@IdBanco int,
@OldIdEntidad int,
@NewIdEntidad int
AS
BEGIN

	UPDATE [PLE].[T3Banco] SET IdEntidad = @NewIdEntidad where ID = @IdBanco

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END