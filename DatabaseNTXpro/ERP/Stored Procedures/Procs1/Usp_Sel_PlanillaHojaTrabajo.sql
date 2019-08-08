CREATE PROCEDURE [ERP].[Usp_Sel_PlanillaHojaTrabajo]
@Data VARCHAR(MAX)
AS
BEGIN

	DECLARE @TABLE TABLE(
		ID INT NOT NULL,
		[Index] INT,
		Nombre VARCHAR(250),
		FechaInicio DATETIME,
		FechaFin DATETIME
	)

	DECLARE @XMLDATA AS XML = CONVERT(XML, @Data)

	INSERT INTO @TABLE
	SELECT 
		T.N.value('ID[1]', 'INT'),
		T.N.value('Index[1]', 'INT'),
		T.N.value('Nombre[1]', 'VARCHAR(250)'),
		CONVERT(DATETIME, T.N.value('FechaInicioStr[1]', 'VARCHAR(50)'), 103),
		CONVERT(DATETIME, T.N.value('FechaFinStr[1]', 'VARCHAR(50)'), 103)
	FROM
	@XMLDATA.nodes('/PlanillaCalculo') AS T(N)


	
	DECLARE @fechaXinicio datetime 
	DECLARE @fechaXfin datetime 
		SELECT @fechaXinicio =  T.N.value('FechaInicio[1]', 'datetime'),
		 @fechaXfin =  T.N.value('FechaFin[1]', 'datetime')
	FROM
	@XMLDATA.nodes('/PlanillaCalculo') AS T(N)



	DECLARE @COLUMNAS AS NVARCHAR(MAX);
    DECLARE @QUERY  AS NVARCHAR(MAX);

	SET @COLUMNAS = STUFF((SELECT ',' + QUOTENAME(C.Nombre)
							FROM [ERP].[PlanillaHojaTrabajo] PHT
							INNER JOIN [ERP].[PlanillaCabecera] PC ON PHT.IdPlanillaCabecera = PC.ID 
							INNER JOIN @TABLE P ON PC.FechaInicio = P.FechaInicio AND PC.FechaFin = P.FechaFin
							INNER JOIN ERP.Concepto C ON PHT.IdConcepto = C.ID
							GROUP BY C.ID, C.Nombre
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)'),1,1,'');

	IF(@COLUMNAS IS NULL)
	BEGIN
		SELECT
			T.ID AS IdTrabajador,
			TD.Nombre AS NombreTipoDocumento,
			ETD.NumeroDocumento AS NumeroDocumento,
			E.Nombre AS NombreEntidad,
			--0 AS IdPlanillaCabecera,
			--(SELECT top 1 id FROM ERP.PlanillaCabecera pc2 WHERE pc2.IdDatoLaboralDetalle = dld.ID) AS IdPlanillaCabecera,
			(SELECT top 1 id FROM ERP.PlanillaCabecera pc2 WHERE pc2.IdDatoLaboralDetalle = dld.ID AND pc2.FechaIniPlanilla = @fechaXinicio AND pc2.FechaFinPlanilla = @fechaXfin ) AS IdPlanillaCabecera,
			CONVERT(VARCHAR(10), DLD.FechaInicio, 103) AS FechaIniDLD,
			CONVERT(VARCHAR(10), DLD.FechaFin, 103) AS FechaFinDLD
		FROM @TABLE P
		INNER JOIN ERP.DatoLaboralDetalle DLD ON P.ID = DLD.IdPlanilla 
		--AND
		--	((P.FechaInicio BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
		--	 (P.FechaFin BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
		--	 (DLD.FechaInicio < P.FechaInicio AND DLD.FechaFin IS NULL))
		INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
		INNER JOIN ERP.Trabajador T ON DL.IdTrabajador = T.ID
		INNER JOIN ERP.Entidad E ON T.IdEntidad = E.ID
		INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID	
		INNER JOIN PLE.T2TipoDocumento TD ON ETD.IdTipoDocumento = TD.ID
		 where
			 ((DL.FechaCese >= P.FechaInicio OR dl.FechaCese IS null) )	   
              AND (DL.FechaInicio <= P.FechaFin)
		ORDER BY E.Nombre
	END
	ELSE
	BEGIN
		SET @QUERY = '
		DECLARE @TABLE TABLE(
			ID INT NOT NULL,
			[Index] INT,
			Nombre VARCHAR(250),
			FechaInicio DATETIME,
			FechaFin DATETIME
		)

		DECLARE @XMLDATA AS XML = CONVERT(XML, ''' + @Data + ''')
	
		INSERT INTO @TABLE
		SELECT 
			T.N.value(''ID[1]'', ''INT''),
			T.N.value(''Index[1]'', ''INT''),
			T.N.value(''Nombre[1]'', ''VARCHAR(250)''),
			CONVERT(DATETIME, T.N.value(''FechaInicioStr[1]'', ''VARCHAR(50)''), 103),
			CONVERT(DATETIME, T.N.value(''FechaFinStr[1]'', ''VARCHAR(50)''), 103)
		FROM
		@XMLDATA.nodes(''/PlanillaCalculo'') AS T(N)

		SELECT
			IdTrabajador,
			NombreTipoDocumento,
			NumeroDocumento,
			NombreEntidad,
			IdPlanillaCabecera,
			' + @COLUMNAS + '
			,idDatoLaboralDetalle
			,CONVERT(VARCHAR(10),(SELECT TOP 1 dld2.FechaInicio from ERP.DatoLaboralDetalle dld2 WHERE dld2.ID =idDatoLaboralDetalle) , 103) AS FechaIniDLD
			,CONVERT(VARCHAR(10),(SELECT TOP 1 dld2.FechaFin from ERP.DatoLaboralDetalle dld2 WHERE dld2.ID =idDatoLaboralDetalle) , 103) AS FechaFinDLD
		FROM
		(SELECT
			T.ID AS IdTrabajador,
			E.ID AS IdEntidad,
			TD.Nombre AS NombreTipoDocumento,
			ETD.NumeroDocumento,
			E.Nombre AS NombreEntidad,
			C.Nombre AS NombreConcepto,
			PHT.IdPlanillaCabecera,
			SUM(HoraPorcentaje) AS HoraPorcentaje,
			pc.idDatoLaboralDetalle
		FROM @TABLE P
		INNER JOIN ERP.DatoLaboralDetalle DLD ON P.ID = DLD.IdPlanilla
		    -- AND
			--((P.FechaInicio BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
			-- (P.FechaFin BETWEEN DLD.FechaInicio AND DLD.FechaFin) OR
			-- (DLD.FechaInicio < P.FechaInicio AND DLD.FechaFin IS NULL))
		INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
		INNER JOIN ERP.Trabajador T ON DL.IdTrabajador = T.ID
		INNER JOIN ERP.Entidad E ON T.IdEntidad = E.ID
		INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID	
		INNER JOIN PLE.T2TipoDocumento TD ON ETD.IdTipoDocumento = TD.ID
		LEFT JOIN ERP.PlanillaCabecera PC ON T.ID = PC.IdTrabajador AND P.FechaInicio = PC.FechaInicio AND P.FechaFin = PC.FechaFin
		LEFT JOIN ERP.PlanillaHojaTrabajo PHT ON PC.ID = PHT.IdPlanillaCabecera
		LEFT JOIN ERP.Concepto C ON PHT.IdConcepto = C.ID
		 where
			 ((DL.FechaCese >= P.FechaInicio OR dl.FechaCese IS null) )	   
              AND (DL.FechaInicio <= P.FechaFin)
		GROUP BY
		T.ID,
		E.ID,
		TD.Nombre,
		ETD.NumeroDocumento,
		E.Nombre,
		C.Nombre,
		PHT.IdPlanillaCabecera,
		pc.idDatoLaboralDetalle
		) AS TEMP
		PIVOT
		(
			SUM(TEMP.HoraPorcentaje)
			FOR TEMP.NombreConcepto IN (' + @COLUMNAS + ')
		) AS P ORDER BY NombreEntidad';

		EXECUTE(@QUERY);
	END
END