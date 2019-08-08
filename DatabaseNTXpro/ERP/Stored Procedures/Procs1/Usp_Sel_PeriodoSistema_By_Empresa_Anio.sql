CREATE PROC ERP.Usp_Sel_PeriodoSistema_By_Empresa_Anio
@IdEmpresa INT,
@IdAnio INT
AS
BEGIN
	
	SELECT 
		ID,
		IdPeriodo,
		IdSistema,
		FlagCierre
	FROM ERP.PeriodoSistema
	WHERE IdEmpresa = @IdEmpresa AND IdPeriodo IN (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio)

END