
CREATE PROC [ERP].[Usp_Ins_Operacion_Empresa]
@IdEmpresa INT,
@IdEmpresaPlantilla INT
AS
BEGIN
	DECLARE @IdPlanCuenta INT = (SELECT TOP 1 ID FROM ERP.PlanCuenta WHERE IdEmpresa = @IdEmpresa)

		INSERT INTO ERP.Operacion
		([Nombre]
			  ,[IdTipoMovimiento]
			  ,[IdPlanCuenta]
			  ,[FechaModificado]
			  ,[UsuarioRegistro]
			  ,[UsuarioModifico]
			  ,[UsuarioElimino]
			  ,[UsuarioActivo]
			  ,[FechaActivacion]
			  ,[IdEmpresa]
		)
		SELECT [Nombre]
			  ,[IdTipoMovimiento]
			  ,@IdPlanCuenta
			  ,[FechaModificado]
			  ,[UsuarioRegistro]
			  ,[UsuarioModifico]
			  ,[UsuarioElimino]
			  ,[UsuarioActivo]
			  ,[FechaActivacion]
			  ,@IdEmpresa
		  FROM [ERP].[Operacion]
		  WHERE IdEmpresa = @IdEmpresaPlantilla
END
