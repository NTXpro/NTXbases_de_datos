CREATE PROC ERP.Usp_Sel_Talonario_By_ID
@IdTalonario INT
AS
BEGIN
	
	SELECT [ID]
			,[IdCuenta]
			,[Fecha]
			,[Inicio]
			,[Fin]
			,[Total]
			,[Girado]
			,[Anulado]
			,[Ultimo]
			,[IdEmpresa]
			,[UsuarioRegistro]
			,[UsuarioModifico]
			,[UsuarioElimino]
			,[UsuarioActivo]
			,[FechaRegistro]
			,[FechaModificado]
			,[FechaEliminado]
			,[FechaActivacion]
			,[Flag]
			,[FlagBorrador]
			,(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](IdCuenta)) NombreBancoMonedaTipo
	FROM ERP.Talonario
	WHERE ID = @IdTalonario

END