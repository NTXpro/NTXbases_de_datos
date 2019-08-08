
CREATE PROC [ERP].[Usp_Upd_TrabajadorFamilia]
@ID INT,
@IdDatoLaboral INT,
@IdTrabajador INT,
@IdEntidad INT,
@IdVinculoFamiliar INT,
@IdEmpresa INT,
@IdEstablecimiento INT,
@FechaAlta DATETIME,
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
	DECLARE @FECHA_ACTUAL DATETIME = (SELECT ERP.ObtenerFechaActual());
	DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);
	DECLARE @Count_Entidad INT = (SELECT COUNT(ID) FROM ERP.TrabajadorFamilia WHERE IdEntidad = @IdEntidad AND IdTrabajador = @IdTrabajador AND ID != @ID)

	IF(@Count_Entidad > 0)
	BEGIN
		SET @ID = -2;
		SELECT @ID;
	END
	ELSE IF(@FechaAlta >= @FECHA_INICIO_LABORAL)
	BEGIN
			UPDATE ERP.TrabajadorFamilia SET
							IdEntidad = @IdEntidad,
							IdVinculoFamiliar = @IdVinculoFamiliar,
							IdEstablecimiento = @IdEstablecimiento,
							FechaDeAlta = @FechaAlta,
							UsuarioModifico = @UsuarioRegistro,
							FechaModificado = @FECHA_ACTUAL
			WHERE ID = @ID
			SELECT @ID;
	END
	ELSE
	BEGIN
		SET @ID = -1;
		SELECT @ID;
	END
END
