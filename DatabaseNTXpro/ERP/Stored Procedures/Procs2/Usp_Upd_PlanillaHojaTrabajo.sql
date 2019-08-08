
CREATE PROC [ERP].[Usp_Upd_PlanillaHojaTrabajo]
@IdEmpresa INT,
@ValorAnio INT,
@ValorMes INT,
@IdPlanilla INT,
@FechaInicio DATETIME,
@FechaFin DATETIME,
@XMLPlanillaHojaTrabajo XML,
@XMLPlanillaPago XML,
@CodigoProceso VARCHAR(250)
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 100000;
		DECLARE @IdPeriodo INT = (SELECT P.ID FROM
								  ERP.Periodo P
								  INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
								  INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
								  WHERE A.Nombre = @ValorAnio AND M.Valor = @ValorMes)
        DECLARE @IdPlanillaCabecera INT
		DECLARE @PlanillaPago TABLE(
			IdConcepto INT, 
			SueldoMinimo DECIMAL(18,2), 
			Calculo DECIMAL(18,2),
			Orden INT
		);

		DECLARE @PlanillaHojaTrabajo TABLE(
			IdConcepto INT, 
			HoraPorcentaje DECIMAL(18,2),
			Orden INT,
			IdTrabajador INT
		);

	BEGIN TRY

	----	ELIMINAR TODO CALCULO ANTERIOR
		DELETE FROM ERP.PlanillaPago WHERE ERP.PlanillaPago.IdPlanillaCabecera IN 
		(SELECT DISTINCT T.N.value('IdPlanillaCabecera[1]', 'INT')
		FROM @XMLPlanillaPago.nodes('/XmlPlanillaPago') AS T(N) )		
		
	---- INSERTAR CALCULOS NUEVOS
		
		INSERT ERP.PlanillaPago
		(
		    --ID - this column value is auto-generated
		    IdPlanillaCabecera,
		    IdConcepto,
		    SueldoMinimo,
		    Calculo
		)
		SELECT
		    T.N.value('IdPlanillaCabecera[1]', 'INT') AS IdPlanillaCabecera,
			T.N.value('IdConcepto[1]', 'INT') AS IdConcepto,
			T.N.value('SueldoMinimo[1]', 'DECIMAL(18,2)') AS SueldoMinimo,
			T.N.value('Calculo[1]', 'DECIMAL(18,5)') AS Calculo 	
		FROM @XMLPlanillaPago.nodes('/XmlPlanillaPago') AS T(N)

		SELECT 1
END TRY
BEGIN CATCH
       SELECT ERROR_NUMBER() AS IdError
END CATCH
	--BEGIN -- DECLARACIONES

	--	DECLARE @IdPeriodo INT = (SELECT P.ID FROM
	--							  ERP.Periodo P
	--							  INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	--							  INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	--							  WHERE A.Nombre = @ValorAnio AND M.Valor = @ValorMes)

	--	DECLARE @PlanillaPago TABLE(
	--		IdConcepto INT, 
	--		SueldoMinimo DECIMAL(18,2), 
	--		Calculo DECIMAL(18,2),
	--		Orden INT
	--	);

	--	DECLARE @PlanillaHojaTrabajo TABLE(
	--		IdConcepto INT, 
	--		HoraPorcentaje DECIMAL(18,2),
	--		Orden INT,
	--		IdTrabajador INT
	--	);

	--	DECLARE @IdsCabeceraDelete TABLE(ID INT);

	--	INSERT INTO @PlanillaPago
	--	SELECT
	--		T.N.value('IdConcepto[1]', 'INT'),
	--		T.N.value('SueldoMinimo[1]', 'DECIMAL(18,2)'),
	--		T.N.value('Calculo[1]', 'DECIMAL(18,5)'),
	--		T.N.value('Index[1]', 'INT')
	--	FROM @XMLPlanillaPago.nodes('/XmlPlanillaPago') AS T(N)

	--	INSERT INTO @PlanillaHojaTrabajo
	--	SELECT
	--		T.N.value('IdConcepto[1]', 'INT'),
	--		T.N.value('HoraPorcentaje[1]', 'DECIMAL(18,2)'),
	--		T.N.value('Index[1]', 'INT'),
	--		T.N.value('IdTrabajador[1]', 'INT')
	--	FROM @XMLPlanillaHojaTrabajo.nodes('/XmlPlanillaHojaTrabajo') AS T(N)

	--	INSERT INTO @IdsCabeceraDelete
	--	SELECT ID FROM [ERP].[PlanillaCabecera]
	--	WHERE
	--	FechaInicio = @FechaInicio AND
	--	FechaFin = @FechaFin AND
	--	IdEmpresa = @IdEmpresa AND
	--	IdPlanilla = @IdPlanilla AND
	--	IdPeriodo = @IdPeriodo;

	--END

	--BEGIN -- ELIMINAR PLANILLAS CABECERA, PAGO, HOJA DE TRABAJO

	--	DELETE FROM [ERP].[PlanillaHojaTrabajo] 
	--	WHERE IdPlanillaCabecera IN (SELECT ID FROM @IdsCabeceraDelete)

	--	DELETE FROM [ERP].[PlanillaPago]
	--	WHERE IdPlanillaCabecera IN (SELECT ID FROM @IdsCabeceraDelete)

	--	DELETE FROM [ERP].[PlanillaCabecera]
	--	WHERE ID IN (SELECT ID FROM @IdsCabeceraDelete)

	--END

	--BEGIN -- INSERTAR PLANILLA CABECERA

	--	INSERT INTO [ERP].[PlanillaCabecera](
	--		IdEmpresa, 
	--		IdPeriodo, 
	--		IdPlanilla,
	--		IdTrabajador ,
	--		FechaInicio, 
	--		FechaFin, 
	--		Orden,
	--		CodigoProceso)
	--	SELECT 
	--		@IdEmpresa, 
	--		@IdPeriodo, 
	--		@IdPlanilla,
	--		IdTrabajador, 
	--		@FechaInicio,
	--		@FechaFin,
	--		Orden,
	--		@CodigoProceso
	--	FROM @PlanillaHojaTrabajo GROUP BY IdTrabajador, Orden;

	--END

	--BEGIN -- INSERTAR PLANILLA HOJA TRABAJO

	--	INSERT INTO [ERP].[PlanillaHojaTrabajo](
	--		IdPlanillaCabecera,
	--		IdConcepto,
	--		HoraPorcentaje)
	--	SELECT
	--		[PC].[ID],
	--		[PHT].[IdConcepto],
	--		[PHT].[HoraPorcentaje]
	--	FROM @PlanillaHojaTrabajo PHT
	--	INNER JOIN [ERP].[PlanillaCabecera] PC ON PHT.Orden = PC.Orden AND PC.CodigoProceso = @CodigoProceso

	--END

	--BEGIN -- INSERTAR PLANILLA PAGO

	--	INSERT INTO [ERP].[PlanillaPago](
	--		IdPlanillaCabecera,
	--		IdConcepto,
	--		SueldoMinimo,
	--		Calculo)
	--	SELECT
	--		[PC].[ID],
	--		[PP].[IdConcepto],
	--		[PP].[SueldoMinimo],
	--		[PP].[Calculo]
	--	FROM @PlanillaPago PP
	--	INNER JOIN [ERP].[PlanillaCabecera] PC ON PP.Orden = PC.Orden AND PC.CodigoProceso = @CodigoProceso

	--END

	--UPDATE [ERP].[PlanillaCabecera] SET CodigoProceso = NULL
	--WHERE CodigoProceso = @CodigoProceso

	--SELECT 1;
END