
CREATE PROC [ERP].[Usp_Upd_Entidad_Chofer]
@IdChofer INT,
@OldIdEntidad INT,
@NewIdEntidad INT
AS
BEGIN

	UPDATE ERP.Chofer SET IdEntidad = @NewIdEntidad where ID = @IdChofer

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Entidad] @OldIdEntidad
	END
	
END
