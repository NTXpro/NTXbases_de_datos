
CREATE PROC [ERP].[Usp_Upd_TrabajadorFamilia_Baja]
@ID INT,
@FechaBaja DATETIME,
@IdMotivoBaja INT,
@UsuarioBaja VARCHAR(250)
AS
BEGIN
	DECLARE @FechaAlta DATETIME = (SELECT FechaDeAlta FROM ERP.TrabajadorFamilia WHERE ID = @ID)

	IF CAST(@FechaAlta AS DATE) <= CAST(@FechaBaja AS DATE)
	BEGIN
		UPDATE ERP.TrabajadorFamilia set FlagBaja = 1, FechaBaja = @FechaBaja, IdMotivoBaja = @IdMotivoBaja, UsuarioBaja = @UsuarioBaja
		WHERE ID = @ID
		SELECT @ID
	END
	ELSE
	BEGIN
		SELECT -1
	END
END
