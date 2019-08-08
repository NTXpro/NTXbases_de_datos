CREATE PROC ERP.Usp_Validar_Numero_Talonario
@IdTalonario INT,
@IdCuenta INT,
@IdEmpresa INT,
@Inicio INT,
@Fin INT
AS
BEGIN
	---SE VALIDA SI EL NUMERO DE INICIO Y FIN SE ENCUENTRAN DENTRO DE ALGUN TALONARIO
	DECLARE @Count_Exist INT = (SELECT COUNT(ID) FROM ERP.Talonario WHERE  ((@Inicio>=Inicio AND @Inicio<=Fin) OR (@Fin>=Inicio AND @Fin<= Fin)) AND ID != @IdTalonario AND IdEmpresa = @IdEmpresa AND IdCuenta = @IdCuenta AND FlagBorrador = 0);

	IF @Count_Exist > 0
	BEGIN
		SELECT(1)
	END
	ELSE
	BEGIN
		SELECT(0)
	END
END