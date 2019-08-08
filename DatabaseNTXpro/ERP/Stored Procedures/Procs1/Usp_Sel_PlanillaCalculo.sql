CREATE PROC [ERP].[Usp_Sel_PlanillaCalculo]
@Data XML
AS
BEGIN

	DECLARE @TABLE TABLE(
		ID INT NOT NULL, 
		Nombre VARCHAR(250),
		Codigo VARCHAR(20),
		Dia INT,
		FechaInicio DATETIME,
		FechaFin DATETIME,
		[Index] INT
	);
	
	INSERT INTO @TABLE
	SELECT 
		T.N.value('ID[1]', 'INT'),
		T.N.value('Nombre[1]', 'VARCHAR(250)'),
		T.N.value('Codigo[1]', 'VARCHAR(20)'),
		T.N.value('Dia[1]', 'INT'),
		CONVERT(DATETIME, T.N.value('FechaInicioStr[1]', 'VARCHAR(50)'), 103),
		CONVERT(DATETIME, T.N.value('FechaFinStr[1]', 'VARCHAR(50)'), 103),
		T.N.value('Index[1]', 'INT')
	FROM
	@Data.nodes('/PlanillaCalculo') AS T(N);

	SELECT
		P.ID,
		P.Nombre,
		P.Codigo,
		P.Dia,
		TPLA.Nombre AS NombreTipoPlanilla,
		TPLA.Codigo AS CodigoTipoPlanilla,
		COUNT(DL.ID) AS CantidadEmpleado,
		P.FechaInicio,
		P.FechaFin,
		P.[Index]
	FROM @TABLE P
	INNER JOIN Maestro.Planilla PLA ON PLA.ID = P.ID
	INNER JOIN Maestro.TipoPlanilla TPLA ON PLA.IdTipoPlanilla = TPLA.ID
	LEFT JOIN ERP.DatoLaboralDetalle DLD ON P.ID = DLD.IdPlanilla AND
		((P.FechaInicio BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
		 (P.FechaFin BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
		 (DLD.FechaInicio < P.FechaInicio OR DLD.FechaFin IS NULL))
	LEFT JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
	GROUP BY
	P.ID,
	P.Nombre,
	P.Codigo,
	P.Dia,
	TPLA.Nombre,
	TPLA.Codigo,
	P.FechaInicio,
	P.FechaFin,
	P.[Index]
END