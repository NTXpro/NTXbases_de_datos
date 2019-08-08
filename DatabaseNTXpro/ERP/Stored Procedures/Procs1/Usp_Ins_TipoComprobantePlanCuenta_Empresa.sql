
CREATE PROC [ERP].[Usp_Ins_TipoComprobantePlanCuenta_Empresa]
@IdEmpresa INT,
@IdEmpresaPlantilla INT
AS
BEGIN

	INSERT INTO ERP.TipoComprobantePlanCuenta(IdEmpresa
											,IdTipoComprobante
											,IdTipoRelacion
											,IdMoneda
											,IdPlanCuenta
											,IdSistema
											,Nombre
											,IdAnio
											,Abreviatura
											,FechaRegistro
											,FechaEliminado
											,FlagBorrador
											,Flag
											,FechaModificado
											,UsuarioRegistro
											,UsuarioModifico
											,UsuarioElimino
											,UsuarioActivo
											,FechaActivacion)
				SELECT @IdEmpresa  
					   ,TCPC.IdTipoComprobante
					   ,TCPC.IdTipoRelacion
					   ,TCPC.IdMoneda
					   ,(SELECT TOP 1 ID FROM ERP.PlanCuenta WHERE IdEmpresa = @IdEmpresa AND IdAnio = TCPC.IdAnio AND CuentaContable = (SELECT TOP 1 CuentaContable FROM ERP.PlanCuenta WHERE ID = TCPC.IdPlanCuenta))
					   ,TCPC.IdSistema
					   ,TCPC.Nombre
					   ,TCPC.IdAnio
					   ,TCPC.Abreviatura
					   ,TCPC.FechaRegistro
					   ,TCPC.FechaEliminado
					   ,TCPC.FlagBorrador
					   ,TCPC.Flag
					   ,TCPC.FechaModificado
					   ,TCPC.UsuarioRegistro
					   ,TCPC.UsuarioModifico
					   ,TCPC.UsuarioElimino
					   ,TCPC.UsuarioActivo
					   ,TCPC.FechaActivacion
				FROM ERP.TipoComprobantePlanCuenta TCPC WHERE TCPC.IdEmpresa = @IdEmpresaPlantilla AND TCPC.FlagBorrador = 0 AND TCPC.Flag = 1
	
END
