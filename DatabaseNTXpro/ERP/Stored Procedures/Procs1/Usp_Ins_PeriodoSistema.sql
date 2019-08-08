CREATE PROC ERP.Usp_Ins_PeriodoSistema
@IdEmpresa INT,
@IdSistema INT,
@IdPeriodo INT,
@FlagCierre BIT
AS
BEGIN
	
	DECLARE @IdPeriodoSistema INT = (SELECT ID FROM ERP.PeriodoSistema WHERE IdPeriodo = @IdPeriodo AND IdSistema = @IdSistema AND IdEmpresa = @IdEmpresa)

	IF @IdPeriodoSistema IS NULL
		BEGIN
			INSERT INTO ERP.PeriodoSistema(IdSistema, IdEmpresa, IdPeriodo, FlagCierre, Fecha)
			VALUES (@IdSistema, @IdEmpresa, @IdPeriodo, @FlagCierre, GETDATE())
		END
	ELSE
		BEGIN
			UPDATE ERP.PeriodoSistema SET FlagCierre = @FlagCierre WHERE ID = @IdPeriodoSistema
		END		

END