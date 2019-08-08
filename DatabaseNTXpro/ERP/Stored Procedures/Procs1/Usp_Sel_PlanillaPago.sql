--[ERP].[Usp_Sel_PlanillaPago] '<PlanillaCalculo><ID>1</ID><Nombre>EMPLEADOS</Nombre><Codigo>E</Codigo><Dia>0</Dia><CantidadEmpleado>0</CantidadEmpleado><FechaInicio>2017-12-01T00:00:00</FechaInicio><FechaFin>2017-12-31T00:00:00</FechaFin><FechaInicioStr>01/12/2017</FechaInicioStr><FechaFinStr>31/12/2017</FechaFinStr><Index>1</Index><TipoPlanilla><ID>0</ID><Nombre>MENSUAL</Nombre><Codigo>M</Codigo></TipoPlanilla></PlanillaCalculo>'
CREATE PROC [ERP].[Usp_Sel_PlanillaPago] --1, '<PlanillaCalculo><ID>6</ID><Nombre>AIO</Nombre><Codigo>E</Codigo><Dia>0</Dia><CantidadEmpleado>0</CantidadEmpleado><FechaInicio>2017-01-01T00:00:00</FechaInicio><FechaFin>2017-01-31T00:00:00</FechaFin><FechaInicioStr>01/01/2017</FechaInicioStr><FechaFinStr>31/01/2017</FechaFinStr><Index>1</Index><FlagDiaMes>false</FlagDiaMes><TipoPlanilla><ID>0</ID><Nombre>MENSUAL</Nombre><Codigo>M</Codigo></TipoPlanilla></PlanillaCalculo>'
@IdEmpresa   INT,
@Data VARCHAR(MAX)
AS
BEGIN

	DECLARE @COLUMNAS AS NVARCHAR(MAX);
    DECLARE @QUERY  AS NVARCHAR(MAX);
	DECLARE @XMLDATA AS XML = CONVERT(XML, @Data)
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
	@XMLDATA.nodes('/PlanillaCalculo') AS T(N);

	--SET @COLUMNAS = STUFF((SELECT ',' + QUOTENAME(CONCAT(C.ID, '|', C.IdTipoConcepto, '|', C.Nombre))
	--						FROM [ERP].[PlanillaPago] PHT
	--						INNER JOIN [ERP].[PlanillaCabecera] PC ON PHT.IdPlanillaCabecera = PC.ID 
	--						INNER JOIN @TABLE P ON PC.FechaInicio = P.FechaInicio AND PC.FechaFin = P.FechaFin
	--						INNER JOIN ERP.Concepto C ON PHT.IdConcepto = C.ID
	--						WHERE C.IdEmpresa = @IdEmpresa
	--						GROUP BY C.ID, C.IdTipoConcepto, C.Nombre
	--						FOR XML PATH(''), TYPE
	--						).value('.', 'NVARCHAR(MAX)'),1,1,'');

	--IF(@COLUMNAS IS NULL)
	--BEGIN
		SELECT
			T.ID AS IdTrabajador,
			TD.Abreviatura AS AbreviaturaTipoDocumento,
			ETD.NumeroDocumento AS NumeroDocumento,
			E.Nombre AS NombreEntidad,
			CONVERT(VARCHAR(10), P.FechaInicio, 103) AS FechaInicioStr,
			CONVERT(VARCHAR(10), P.FechaFin, 103) AS FechaFinStr,
		
	        DLD.ID,
			CONVERT(VARCHAR(10), DLD.FechaInicio, 103) AS FechaIniDLD,
			--CONVERT(VARCHAR(10), DLD.FechaFin, 103) AS FechaFinDLD
			CONVERT(VARCHAR(10), DL.FechaCese, 103) AS FechaFinDLD
		FROM @TABLE P
	    INNER JOIN ERP.DatoLaboralDetalle DLD ON P.ID = DLD.IdPlanilla 
		--AND
		--((DLD.FechaInicio BETWEEN P.FechaInicio AND P.FechaFin) OR(DLD.FechaFin BETWEEN P.FechaInicio AND P.FechaFin) OR
		--(DLD.FechaInicio <= P.FechaInicio OR DLD.FechaFin IS NULL))
		INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
		--AND ((DL.FechaCese >= P.FechaFin OR dl.FechaCese IS null) AND (dl.FechaCese>= p.FechaInicio  OR dl.FechaCese IS null))

		AND ((DL.FechaCese >= P.FechaInicio OR dl.FechaCese IS null) )	   
        AND (DL.FechaInicio <= P.FechaFin)

		INNER JOIN ERP.Trabajador T ON DL.IdTrabajador = T.ID
		INNER JOIN ERP.Entidad E ON T.IdEntidad = E.ID
		INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID	
		INNER JOIN PLE.T2TipoDocumento TD ON ETD.IdTipoDocumento = TD.ID
		ORDER BY E.Nombre
	END
--	ELSE
--	BEGIN
--		SET @QUERY = '
--		DECLARE @XMLDATA AS XML = CONVERT(XML, ''' + @Data + ''')
--		DECLARE @TABLE TABLE(
--			ID INT NOT NULL,
--			[Index] INT,
--			Nombre VARCHAR(250),
--			FechaInicio DATETIME,
--			FechaFin DATETIME
--		)

--		INSERT INTO @TABLE
--		SELECT 
--			T.N.value(''ID[1]'', ''INT''),
--			T.N.value(''Index[1]'', ''INT''),
--			T.N.value(''Nombre[1]'', ''VARCHAR(250)''),
--			CONVERT(DATETIME, T.N.value(''FechaInicioStr[1]'', ''VARCHAR(50)''), 103),
--			CONVERT(DATETIME, T.N.value(''FechaFinStr[1]'', ''VARCHAR(50)''), 103)
--		FROM
--		@XMLDATA.nodes(''/PlanillaCalculo'') AS T(N)

--		SELECT
--			IdTrabajador,
--			AbreviaturaTipoDocumento,
--			NumeroDocumento,
--			NombreEntidad,
--			FechaInicioStr,
--			FechaFinStr,
--			' + @COLUMNAS + ',
--			idDatoLaboralDetalle, 
--			FechaIniDLD,
--			FechaFinDLD
--		FROM
--		(SELECT 
--		T.ID AS IdTrabajador,
--			TD.Abreviatura AS AbreviaturaTipoDocumento,
--			ETD.NumeroDocumento,
--			E.Nombre AS NombreEntidad,
--			CONVERT(VARCHAR(10), P.FechaInicio, 103) AS FechaInicioStr,
--			CONVERT(VARCHAR(10), P.FechaFin, 103) AS FechaFinStr,
--			CONCAT(C.ID, ''|'', C.IdTipoConcepto,''|'', C.Nombre) AS NombreConcepto,
--			SUM(PP.Calculo) AS Calculo,
--			pc.idDatoLaboralDetalle,
--			CONVERT(VARCHAR(10),(SELECT TOP 1 dld2.FechaInicio from ERP.DatoLaboralDetalle dld2 WHERE dld2.ID =pc.idDatoLaboralDetalle) , 103) AS FechaIniDLD,
--			CONVERT(VARCHAR(10),(SELECT TOP 1 dld2.FechaFin from ERP.DatoLaboralDetalle dld2 WHERE dld2.ID =pc.idDatoLaboralDetalle) , 103) AS FechaFinDLD
--		 FROM  ERP.DatoLaboralDetalle DLD 
--		inner JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID 
--		INNER JOIN @TABLE P ON  P.ID = DLD.IdPlanilla
--		 LEFT JOIN ERP.Trabajador T ON DL.IdTrabajador = T.ID
--		  LEFT JOIN ERP.Entidad E ON T.IdEntidad = E.ID
--             LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
--             LEFT JOIN PLE.T2TipoDocumento TD ON ETD.IdTipoDocumento = TD.ID
--			 LEFT JOIN ERP.PlanillaCabecera PC ON T.ID = PC.IdTrabajador AND P.FechaInicio = PC.FechaInicio AND P.FechaFin = PC.FechaFin
--			 LEFT JOIN ERP.PlanillaPago PP ON PC.ID = PP.IdPlanillaCabecera
--		LEFT JOIN ERP.Concepto C ON PP.IdConcepto = C.ID
--		WHERE
--		DL.IdEmpresa = CAST(''' + CAST(@IdEmpresa AS VARCHAR(10))  + ''' AS INT)
--		AND ((DLD.FechaInicio BETWEEN P.FechaInicio AND P.FechaFin)
--        OR (DLD.FechaFin BETWEEN P.FechaInicio AND P.FechaFin)
--        OR (DLD.FechaInicio <= P.FechaInicio))
--		GROUP BY
--		T.ID,
--		TD.Abreviatura,
--		ETD.NumeroDocumento,
--		E.Nombre,
--		P.FechaInicio,
--		P.FechaFin,
--		C.ID,
--		C.IdTipoConcepto,
--		C.Nombre,
--		pc.idDatoLaboralDetalle
--		--ORDER BY pc.idDatoLaboralDetalle
--		) AS TEMP
--		PIVOT
--		(
--			SUM(TEMP.Calculo)
--			FOR TEMP.NombreConcepto IN (' + @COLUMNAS + ')
--		) AS P ORDER BY NombreEntidad';

--		EXECUTE(@QUERY);
--	END

--END