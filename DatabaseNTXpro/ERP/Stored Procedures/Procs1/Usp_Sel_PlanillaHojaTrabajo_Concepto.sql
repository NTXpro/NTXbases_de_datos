CREATE PROCEDURE [ERP].[Usp_Sel_PlanillaHojaTrabajo_Concepto]
@Data AS XML
AS
BEGIN

	DECLARE @TABLE TABLE(
		ID INT NOT NULL,
		[Index] INT,
		Nombre VARCHAR(250),
		FechaInicio DATETIME,
		FechaFin DATETIME
	)

	INSERT INTO @TABLE
	SELECT 
		T.N.value('ID[1]', 'INT'),
		T.N.value('Index[1]', 'INT'),
		T.N.value('Nombre[1]', 'VARCHAR(250)'),
		CONVERT(DATETIME, T.N.value('FechaInicioStr[1]', 'VARCHAR(50)'), 103),
		CONVERT(DATETIME, T.N.value('FechaFinStr[1]', 'VARCHAR(50)'), 103)
	FROM
	@Data.nodes('/PlanillaCalculo') AS T(N)

	SELECT C.ID , C.Nombre
	FROM [ERP].[PlanillaHojaTrabajo] PHT
	INNER JOIN [ERP].[PlanillaCabecera] PC ON PHT.IdPlanillaCabecera = PC.ID 
	--INNER JOIN @TABLE P ON PC.FechaInicio = P.FechaInicio AND PC.FechaFin = P.FechaFin
	INNER JOIN ERP.Concepto C ON PHT.IdConcepto = C.ID
	GROUP BY C.ID, C.Nombre

END