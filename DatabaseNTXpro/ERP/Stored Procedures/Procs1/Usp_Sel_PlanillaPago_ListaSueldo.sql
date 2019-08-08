CREATE PROC [ERP].[Usp_Sel_PlanillaPago_ListaSueldo] --'<PlanillaCalculo><ID>1</ID><Nombre>EMPLEADOS</Nombre><Codigo>E</Codigo><Dia>0</Dia><CantidadEmpleado>0</CantidadEmpleado><FechaInicio>2017-11-01T00:00:00</FechaInicio><FechaFin>2017-11-30T00:00:00</FechaFin><FechaInicioStr>01/11/2017</FechaInicioStr><FechaFinStr>30/11/2017</FechaFinStr><Index>1</Index><TipoPlanilla><ID>0</ID><Nombre>MENSUAL</Nombre><Codigo>M</Codigo></TipoPlanilla></PlanillaCalculo>'
@Data XML
AS
BEGIN

	DECLARE @TABLE TABLE(
		ID INT NOT NULL,
		[Index] INT,
		Nombre VARCHAR(250),
		FechaInicio DATETIME,
		FechaFin DATETIME
	);
	
	INSERT INTO @TABLE
	SELECT 
		T.N.value('ID[1]', 'INT'),
		T.N.value('Index[1]', 'INT'),
		T.N.value('Nombre[1]', 'VARCHAR(250)'),
		CONVERT(DATETIME, T.N.value('FechaInicioStr[1]', 'VARCHAR(50)'), 103),
		CONVERT(DATETIME, T.N.value('FechaFinStr[1]', 'VARCHAR(50)'), 103)
	FROM
	@Data.nodes('/PlanillaCalculo') AS T(N);

	SELECT
		T.ID AS IdTrabajador,
		DLD.Sueldo,
		TS.Hora AS HoraTipoSueldo
	FROM @TABLE P
	INNER JOIN ERP.DatoLaboralDetalle DLD ON P.ID = DLD.IdPlanilla AND
		--((DLD.FechaInicio BETWEEN P.FechaInicio AND P.FechaFin) OR
		--(DLD.FechaFin BETWEEN P.FechaInicio AND P.FechaFin) OR
		--(DLD.FechaInicio < P.FechaInicio AND DLD.FechaFin IS NULL))
		((P.FechaInicio BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
		 (P.FechaFin BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
		 (DLD.FechaInicio < P.FechaInicio AND DLD.FechaFin IS NULL))
	INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
	INNER JOIN ERP.Trabajador T ON DL.IdTrabajador = T.ID
	INNER JOIN Maestro.TipoSueldo TS ON DLD.IdTipoSueldo = TS.ID

END
