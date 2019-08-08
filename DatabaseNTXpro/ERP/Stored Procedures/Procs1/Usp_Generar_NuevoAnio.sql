--select * from maestro.grado where IdAnio = 9
--select * from erp.operacion
--select * from erp.plancuenta where idanio = 9
/*
delete from erp.plancuenta where idanio = 9
delete from erp.parametro where idperiodo = 129
delete from erp.tipocomprobanteplancuenta where idanio = 9
delete from maestro.grado where idanio = 9
delete from erp.operacion where idanio is null or idanio = 9
delete from erp.plancuentadestino where idplancuentaorigen in (
select id from erp.plancuenta where idanio = 9
)

*/
CREATE PROC [ERP].[Usp_Generar_NuevoAnio] --2018,2017
@NUEVO_ANIO INT,
@COPIAR_ANIO INT
AS
BEGIN
------NUEVO ANIO
DECLARE @ID_ANIO_NUEVO INT = (SELECT ID FROM Maestro.Anio 
							WHERE Nombre = @NUEVO_ANIO);

DECLARE @ID_PERIODO_NUEVO INT = (SELECT TOP 1 P.ID FROM ERP.Periodo P
							WHERE P.IdAnio = @ID_ANIO_NUEVO AND IdMes = 1);
-------ANIO A COPIAR
DECLARE @ID_ANIO_COPIAR INT = (SELECT ID FROM Maestro.Anio 
							WHERE Nombre = @COPIAR_ANIO);


DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(ID) FROM ERP.Empresa WHERE Flag = 1 AND FlagBorrador = 0)
DECLARE @ListaEmpresaTemp TABLE(INDICE INT,ID INT)

INSERT INTO @ListaEmpresaTemp
SELECT ROW_NUMBER() OVER(ORDER BY ID ASC),ID FROM ERP.Empresa WHERE Flag = 1 AND FlagBorrador = 0
		
DECLARE @i INT = 1;
WHILE @i <= @TOTAL_ITEMS
BEGIN
			
	DECLARE @IdEmpresa INT = (SELECT ID FROM @ListaEmpresaTemp WHERE INDICE = @i)
	
	---------------------INSERTAR PARAMETROS
	INSERT INTO [ERP].[Parametro]
	SELECT
			P.[Nombre]
			,@ID_PERIODO_NUEVO
			,P.[Abreviatura]
			,P.[Valor]
			,P.[IdTipoParametro]
			,P.[FechaRegistro]
			,P.[Flag]
			,P.[IdEmpresa]
			,P.[FechaModificado]
			,P.[UsuarioRegistro]
			,P.[UsuarioModifico]
			,P.[UsuarioElimino]
			,P.[UsuarioActivo]
			,P.[FechaActivacion]
	FROM [ERP].[Parametro] P 
	INNER JOIN ERP.Periodo PE ON P.IdPeriodo = PE.ID
	INNER JOIN Maestro.Mes M ON PE.IdMes = M.ID AND M.Valor IN (SELECT MAX(CAST(M.Valor AS INT)) AS Valor
	FROM [ERP].[Parametro] P 
	INNER JOIN ERP.Periodo PE ON P.IdPeriodo = PE.ID
	INNER JOIN Maestro.Mes M ON PE.IdMes = M.ID
	WHERE P.Abreviatura IN ('CGPDC', 'CPPDC', 'CGPAC', 'CPPAC', 'ISPAD') AND
	IdEmpresa = @IdEmpresa AND PE.IdAnio = @ID_ANIO_COPIAR
	GROUP BY P.Abreviatura)
	WHERE P.Abreviatura IN ('CGPDC', 'CPPDC', 'CGPAC', 'CPPAC', 'ISPAD')
	AND IdEmpresa = @IdEmpresa

	---------------------INSERTAR GRADOS
	INSERT INTO Maestro.Grado (Nombre,
							   Longitud,
							   IdEmpresa,
							   IdAnio)
				SELECT	Nombre,
						Longitud,
						@IdEmpresa,
						@ID_ANIO_NUEVO 
				FROM Maestro.Grado 
				WHERE IdEmpresa = @IdEmpresa AND IdAnio = @ID_ANIO_COPIAR

	---------------------INSERTAR PLANCUENTA
	INSERT INTO ERP.PlanCuenta(	IdEmpresa, 
								IdAnio, 
								CuentaContable, 
								Nombre, 
								IdGrado, 
								IdColumnaBalance, 
								IdMoneda, 
								IdTipoCambio,
								EstadoAnalisis,
								EstadoProyecto,
								FlagBorrador,
								Flag,
								FechaRegistro)
				SELECT PC.IdEmpresa,  
					   @ID_ANIO_NUEVO, 
					   PC.CuentaContable,
					   PC.Nombre, 
					   (SELECT TOP 1 G.ID FROM Maestro.Grado G WHERE G.IdEmpresa = @IdEmpresa AND G.IdAnio = @ID_ANIO_NUEVO AND G.Nombre = (SELECT TOP 1 G2.Nombre FROM Maestro.Grado G2 WHERE G2.ID = PC.IdGrado )), 
					   PC.IdColumnaBalance,
					   PC.IdMoneda, 
					   PC.IdTipoCambio,
					   PC.EstadoAnalisis,
					   PC.EstadoProyecto,
					   PC.FlagBorrador,
					   PC.Flag,
					   PC.FechaRegistro
				FROM ERP.PlanCuenta PC 
				WHERE PC.IdEmpresa = @IdEmpresa AND PC.FlagBorrador = 0 AND PC.Flag = 1 AND IdAnio = @ID_ANIO_COPIAR

	---------------------INSERTAR TIPOCOMPROBANTE_PLANCUENTA
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
			SELECT   TCPC.IdEmpresa  
					,TCPC.IdTipoComprobante
					,TCPC.IdTipoRelacion
					,TCPC.IdMoneda
					,(SELECT TOP 1 ID FROM ERP.PlanCuenta WHERE IdEmpresa = @IdEmpresa AND IdAnio = @ID_ANIO_NUEVO AND CuentaContable = (SELECT TOP 1 CuentaContable FROM ERP.PlanCuenta WHERE ID = TCPC.IdPlanCuenta))
					,TCPC.IdSistema
					,TCPC.Nombre
					,@ID_ANIO_NUEVO
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
			FROM ERP.TipoComprobantePlanCuenta TCPC 
			WHERE TCPC.IdEmpresa = @IdEmpresa AND TCPC.FlagBorrador = 0 AND TCPC.Flag = 1 and TCPC.IdAnio = @ID_ANIO_COPIAR

	---------------------INSERTAR OPERACION
	INSERT INTO ERP.Operacion
		([Nombre]
		      ,IdAnio
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
			  ,@ID_ANIO_NUEVO
			  ,[IdTipoMovimiento]
			  ,(SELECT TOP 1 ID FROM ERP.PlanCuenta WHERE IdEmpresa = @IdEmpresa AND IdAnio = @ID_ANIO_NUEVO AND CuentaContable = (SELECT TOP 1 CuentaContable FROM ERP.PlanCuenta WHERE ID = O.IdPlanCuenta))
			  ,[FechaModificado]
			  ,[UsuarioRegistro]
			  ,[UsuarioModifico]
			  ,[UsuarioElimino]
			  ,[UsuarioActivo]
			  ,[FechaActivacion]
			  ,@IdEmpresa
		  FROM [ERP].[Operacion] O
		  WHERE IdEmpresa = @IdEmpresa


	INSERT INTO [ERP].[PlanCuentaDestino]
	SELECT
		 PC_00.ID
		,PC_11.ID
		,PC_22.ID
		,PCD.[Porcentaje]
		,PCD.[IdEmpresa]
	FROM [ERP].[PlanCuentaDestino] PCD
	INNER JOIN ERP.PlanCuenta PC_0  ON PCD.IdPlanCuentaOrigen = PC_0.ID
	INNER JOIN ERP.PlanCuenta PC_00 ON PC_0.CuentaContable = PC_00.CuentaContable and PC_00.IdEmpresa = @IdEmpresa and PC_00.IdAnio = @ID_ANIO_NUEVO -- AÑO NUEVO

	INNER JOIN ERP.PlanCuenta PC_1  ON PCD.IdPlanCuentaDestino1 = PC_1.ID
	INNER JOIN ERP.PlanCuenta PC_11 ON PC_1.CuentaContable = PC_11.CuentaContable and PC_11.IdEmpresa = @IdEmpresa and PC_11.IdAnio = @ID_ANIO_NUEVO -- AÑO NUEVO

	INNER JOIN ERP.PlanCuenta PC_2  ON PCD.IdPlanCuentaDestino2 = PC_2.ID
	INNER JOIN ERP.PlanCuenta PC_22 ON PC_2.CuentaContable = PC_22.CuentaContable and PC_22.IdEmpresa = @IdEmpresa and PC_22.IdAnio = @ID_ANIO_NUEVO -- AÑO NUEVO
	WHERE 
	PC_0.IdEmpresa = @IdEmpresa AND
	PC_0.IdAnio = @ID_ANIO_COPIAR -- AÑO ANTERIOR
	ORDER BY PCD.ID

	SET @i = @i + 1
END
END









