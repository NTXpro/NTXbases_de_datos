CREATE PROC [ERP].[Usp_Upd_Pension]
@IdPension INT,
@IdTrabajador INT,
@IdRegimenPensionario INT,
@IdTipoComision INT,
@IdEmpresa INT,
@FechaInicio DATETIME,
@CUSPP VARCHAR(20)
AS
BEGIN

	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.TrabajadorPension
							WHERE IdEmpresa = @IdEmpresa AND IdTrabajador = @IdTrabajador AND ID != @IdPension
							ORDER BY ID DESC);

	UPDATE ERP.TrabajadorPension SET	
	IdRegimenPensionario = @IdRegimenPensionario,	
	IdTipoComision = IIF(@IdTipoComision = 0, NULL , @IdTipoComision),		
	IdEmpresa = @IdEmpresa,
	FechaInicio = @FechaInicio,
	CUSPP = @CUSPP
	WHERE ID = @IdPension

	UPDATE ERP.TrabajadorPension SET
	FechaFin = DATEADD(DAY, -1, @FechaInicio)
	WHERE ID = @LAST_ID;

END
