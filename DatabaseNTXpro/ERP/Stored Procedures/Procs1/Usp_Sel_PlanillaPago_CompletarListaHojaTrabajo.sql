/*
DECLARE @Anio INT = 2017;
DECLARE @Mes INT = 12;
DECLARE @IdPlanilla INT = 1;
DECLARE @FechaInicio DATETIME = '2017-11-01 00:00:00.000'
DECLARE @FechaFin DATETIME = '2017-11-30 00:00:00.000'
DECLARE @XMLPlanillaHojaTrabajo XML = '<XmlPlanillaHojaTrabajo><Index>1</Index><IdPlanillaCabecera>195</IdPlanillaCabecera><IdTrabajador>3</IdTrabajador><IdConcepto>1</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>240.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>1</Index><IdPlanillaCabecera>195</IdPlanillaCabecera><IdTrabajador>3</IdTrabajador><IdConcepto>32</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>1.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>2</Index><IdPlanillaCabecera>193</IdPlanillaCabecera><IdTrabajador>1</IdTrabajador><IdConcepto>1</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>240.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>2</Index><IdPlanillaCabecera>193</IdPlanillaCabecera><IdTrabajador>1</IdTrabajador><IdConcepto>32</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>1.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>3</Index><IdPlanillaCabecera>194</IdPlanillaCabecera><IdTrabajador>2</IdTrabajador><IdConcepto>1</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>240.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>3</Index><IdPlanillaCabecera>194</IdPlanillaCabecera><IdTrabajador>2</IdTrabajador><IdConcepto>32</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>1.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>4</Index><IdPlanillaCabecera>196</IdPlanillaCabecera><IdTrabajador>4</IdTrabajador><IdConcepto>1</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>240.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo><XmlPlanillaHojaTrabajo><Index>4</Index><IdPlanillaCabecera>196</IdPlanillaCabecera><IdTrabajador>4</IdTrabajador><IdConcepto>32</IdConcepto><IdTipoConcepto>0</IdTipoConcepto><IdClase>0</IdClase><IdRegimenLaboral>0</IdRegimenLaboral><OrdenClase>0</OrdenClase><FlagAsignacionFamiliar>false</FlagAsignacionFamiliar><HoraPorcentaje>1.00</HoraPorcentaje><Sueldo>0</Sueldo><HoraTipoSueldo>0</HoraTipoSueldo><IdPension>0</IdPension><FlagONP>false</FlagONP></XmlPlanillaHojaTrabajo>'
EXEC [ERP].[Usp_Sel_PlanillaPago_CompletarListaHojaTrabajo] @Anio, @Anio, @IdPlanilla, @FechaInicio, @FechaFin, @XMLPlanillaHojaTrabajo
*/
CREATE PROC [ERP].[Usp_Sel_PlanillaPago_CompletarListaHojaTrabajo]
@Anio INT,
@Mes INT,
@IdPlanilla INT,
@FechaInicio DATETIME,
@FechaFin DATETIME,
@XMLPlanillaHojaTrabajo XML
AS
BEGIN

	DECLARE @IdPeriodo INT = (SELECT TOP 1 P.ID FROM ERP.Periodo P 
								INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
								INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
								WHERE A.Nombre = @Anio AND M.Valor = @Mes)
    DECLARE @TABLE TABLE(
		[Index] INT,
		IdPlanillaCabecera INT,
		IdTrabajador INT,
		IdConcepto INT,
		HoraPorcentaje DECIMAL(18,2)
	);

	INSERT INTO @TABLE
	SELECT
		T.N.value('Index[1]', 'INT') AS [Index],
		T.N.value('IdPlanillaCabecera[1]', 'INT') AS IdPlanillaCabecera,
		T.N.value('IdTrabajador[1]', 'INT') AS IdTrabajador,
		T.N.value('IdConcepto[1]', 'INT') AS IdConcepto,
		T.N.value('HoraPorcentaje[1]', 'DECIMAL(18,2)') AS HoraPorcentaje
	FROM
	@XMLPlanillaHojaTrabajo.nodes('/XmlPlanillaHojaTrabajo') AS T(N);

	SELECT
		T.[Index],
		T.IdPlanillaCabecera,
		T.IdTrabajador,
		T.IdConcepto,
		C.IdTipoConcepto,
		C.IdClase AS IdClase,
		ERP.PlanillaPago_Completar_IdRegimenLaboral(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS IdRegimenLaboral,
		CL.Orden AS OrdenClase,
		isnull (ERP.PlanillaPago_Completar_IdRegimenLaboral(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla),0) AS FlagAsignacionFamiliar,
		T.HoraPorcentaje,
		ERP.PlanillaPago_Completar_sueldo(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS sueldo,
		ERP.PlanillaPago_Completar_Hora(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS HoraTipoSueldo,
		ERP.PlanillaPago_Completar_FlagONP(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS FlagONP,
		ERP.PlanillaPago_Completar_CodigoSunat(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS CodigoSunatRegimenSalud,
		ERP.PlanillaPago_Completar_IdTipoPension(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS IdTipoPension,
		ERP.PlanillaPago_Completar_IdTipoSalud(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS IdTipoSalud,
		ERP.PlanillaPago_Completar_IdAFP(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS IdAFP,
		ERP.PlanillaPago_Completar_Hora(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS HoraTipoSueldo,
		ERP.PlanillaPago_Completar_IdTipoComision(@FechaInicio,@FechaFin, T.IdTrabajador,@IdPlanilla) AS IdTipoComision
	FROM @TABLE T
	INNER JOIN ERP.Concepto C ON T.IdConcepto = C.ID
	INNER JOIN Maestro.Clase CL ON C.IdClase = CL.ID 
	ORDER BY T.IdTrabajador, CL.Orden

--	DECLARE @TABLE TABLE(
--		[Index] INT,
--		IdPlanillaCabecera INT,
--		IdTrabajador INT,
--		IdConcepto INT,
--		HoraPorcentaje DECIMAL(18,2)
--	);

--	INSERT INTO @TABLE
--	SELECT
--		T.N.value('Index[1]', 'INT') AS [Index],
--		T.N.value('IdPlanillaCabecera[1]', 'INT') AS IdPlanillaCabecera,
--		T.N.value('IdTrabajador[1]', 'INT') AS IdTrabajador,
--		T.N.value('IdConcepto[1]', 'INT') AS IdConcepto,
--		T.N.value('HoraPorcentaje[1]', 'DECIMAL(18,2)') AS HoraPorcentaje
--	FROM
--	@XMLPlanillaHojaTrabajo.nodes('/XmlPlanillaHojaTrabajo') AS T(N);

--	SELECT
--		T.[Index],
--		T.IdPlanillaCabecera,
--		T.IdTrabajador,
--		T.IdConcepto,
--		C.IdTipoConcepto,
--		C.IdClase AS IdClase,
--		DLD.IdRegimenLaboral,
--		CL.Orden AS OrdenClase,
--		ISNULL(DL.FlagAsignacionFamiliar, 0) AS FlagAsignacionFamiliar,
--		T.HoraPorcentaje,
--		DLD.Sueldo,
--		TS.Hora AS HoraTipoSueldo,
--		RP.FlagONP,
--		RS.CodigoSunat AS CodigoSunatRegimenSalud,
--		TPE.ID AS IdTipoPension,
--		TSA.ID AS IdTipoSalud,
--		AFP.ID AS IdAFP,
--		P.IdTipoComision
--	FROM @TABLE T
--	INNER JOIN ERP.Concepto C ON T.IdConcepto = C.ID
--	INNER JOIN Maestro.Clase CL ON C.IdClase = CL.ID 
----	INNER JOIN ERP.DatoLaboralDetalle DLD ON DLD.IdPlanilla = @IdPlanilla
--	INNER JOIN (SELECT TOP 1 * FROM ERP.DatoLaboralDetalle dld ORDER BY id DESC) DLD ON DLD.IdPlanilla = @IdPlanilla
--	 AND
--		((DLD.FechaInicio BETWEEN @FechaInicio AND @FechaFin) OR
--		 (DLD.FechaFin BETWEEN @FechaInicio AND @FechaFin) OR
--		 (DLD.FechaInicio < @FechaInicio AND DLD.FechaFin IS NULL))
--		--((@FechaInicio BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
--		-- (@FechaFin BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
--		-- (DLD.FechaInicio < @FechaInicio AND DLD.FechaFin IS NULL))
--	INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID AND DL.IdTrabajador = T.IdTrabajador
--	INNER JOIN Maestro.TipoSueldo TS ON DLD.IdTipoSueldo = TS.ID -- PARA HORA TIPO SUELDO / SIEMPRE OBLIGATORIO
--	LEFT JOIN ERP.TrabajadorPension P ON T.IdTrabajador = P.IdTrabajador 
--	--AND
--	--	((@FechaInicio BETWEEN P.FechaInicio AND P.FechaFin) OR
--	--	 (@FechaFin BETWEEN P.FechaInicio AND P.FechaFin) OR
--		-- (P.FechaInicio < @FechaInicio AND P.FechaFin IS NULL))
--	LEFT JOIN [PLAME].[T11RegimenPensionario] RP ON P.IdRegimenPensionario = RP.ID
--	LEFT JOIN [ERP].[AFP] AFP ON RP.CodigoSunat = AFP.Codigo
--	LEFT JOIN ERP.DatoLaboralSalud S ON DL.ID = S.IdDatoLaboral 
--	--AND
--	--	((@FechaInicio BETWEEN S.FechaInicio AND S.FechaFin) OR
--	--	 (@FechaFin BETWEEN S.FechaInicio AND S.FechaFin) OR
--	--	 (S.FechaInicio < @FechaInicio AND S.FechaFin IS NULL))
--	LEFT JOIN [PLAME].[T32RegimenSalud] RS ON S.IdRegimenSalud = RS.ID
--	LEFT JOIN [ERP].[SCTR] SCTR ON DL.ID = SCTR.IdDatoLaboral 
--	--AND
--	--	((@FechaInicio BETWEEN SCTR.FechaInicio AND SCTR.FechaFin) OR
--	--	 (@FechaFin BETWEEN SCTR.FechaInicio AND SCTR.FechaFin))
--	LEFT JOIN [Maestro].[TipoPension] TPE ON SCTR.IdTipoPension = TPE.ID
--	LEFT JOIN [Maestro].[TipoSalud] TSA ON SCTR.IdTipoSalud = TSA.ID
--	ORDER BY T.IdTrabajador, CL.Orden

END