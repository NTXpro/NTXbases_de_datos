
CREATE PROC [ERP].[Usp_Ins_Pension]
@IdPension INT OUT,
@IdTrabajador INT,
@IdRegimenPensionario INT,
@IdTipoComision INT,
@IdEmpresa INT,
@FechaInicio DATETIME,
@CUSPP VARCHAR(20)
AS
BEGIN

	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.TrabajadorPension
							WHERE IdEmpresa = @IdEmpresa AND IdTrabajador = @IdTrabajador
							ORDER BY ID DESC);

	INSERT INTO ERP.TrabajadorPension(
		IdTrabajador,
		IdRegimenPensionario,
		IdTipoComision,
		IdEmpresa,
		FechaInicio,
		CUSPP)
	VALUES(
		@IdTrabajador,
		@IdRegimenPensionario,
		IIF(@IdTipoComision = 0, NULL , @IdTipoComision),
		@IdEmpresa,
		@FechaInicio,
		@CUSPP)

	SET @IdPension = SCOPE_IDENTITY();

	UPDATE ERP.TrabajadorPension SET
	FechaFin = DATEADD(DAY, -1, @FechaInicio)
	WHERE ID = @LAST_ID;

	SELECT @IdPension

END
