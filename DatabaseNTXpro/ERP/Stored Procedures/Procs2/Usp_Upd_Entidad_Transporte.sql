
CREATE PROC ERP.Usp_Upd_Entidad_Transporte
@IdTransporte INT,
@OldIdEntidad INT,
@NewIdEntidad INT
AS
BEGIN

	UPDATE ERP.Empresa SET IdEntidad = @NewIdEntidad where ID = @IdTransporte

	DECLARE @FlagBorradorEntidad BIT= (SELECT FlagBorrador FROM ERP.Entidad WHERE ID = @OldIdEntidad)

	IF @FlagBorradorEntidad = 1
	BEGIN
		EXEC [ERP].[Usp_Del_Transporte] @OldIdEntidad
	END
	
END
