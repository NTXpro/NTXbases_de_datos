
CREATE PROC [ERP].[Usp_Sel_CTS_By_Periodo]
@IdEmpresa INT,
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
BEGIN
SELECT	 DL.ID IdDatoLaboral
		,DL.IdEmpresa
		,DL.IdTrabajador
		,DL.IdPlanilla
		,DL.FechaInicio
		,DL.FechaCese FechaFin
		,TD.Abreviatura TipoDocumentoTrabajador
		,ETD.NumeroDocumento NumeroDocumentoTrabajador
		,E.Nombre NombreTrabajador
		,DLP.Sueldo
		,DLP.AsignacionFamiliar
		,CAST(0 AS DECIMAL(14,5)) AS Bonificacion
		,CAST(0 AS DECIMAL(14,5)) AS HE25
		,CAST(0 AS DECIMAL(14,5)) AS HE35
		,CAST(0 AS DECIMAL(14,5)) AS HE100
		,CAST(0 AS DECIMAL(14,5)) AS Comision
		,DLP.Gratificacion
		,(DLP.Sueldo + DLP.AsignacionFamiliar + DLP.Gratificacion) AS Remuneracion
		,DLP.Mes
		,((DLP.Sueldo + DLP.AsignacionFamiliar) / 12) AS ValorMes
		,(DLP.Mes * ((DLP.Sueldo + DLP.AsignacionFamiliar) / 12)) AS ImporteMes
		,DLP.Dias
		,((DLP.Sueldo + DLP.AsignacionFamiliar) / 12 / 30) AS ValorDia
		,(DLP.Dias * ((DLP.Sueldo + DLP.AsignacionFamiliar) / 12 / 30)) ImporteDia
		,((DLP.Mes * ((DLP.Sueldo + DLP.AsignacionFamiliar) / 12)) +  (DLP.Dias * ((DLP.Sueldo + DLP.AsignacionFamiliar) / 12 / 30))) AS TotalCTS
FROM ERP.DatoLaboral DL
INNER JOIN ERP.Trabajador T ON T.ID = DL.IdTrabajador
INNER JOIN ERP.Entidad E ON E.ID = T.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID 
INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
INNER JOIN (SELECT DLP.ID IdDatoLaboral
				,(SELECT [ERP].[ObtenerSueldoDatoLaboralByFecha](DLP.ID, @FechaFin)) AS Sueldo
				,(SELECT [ERP].[ObtenerAsignacionFamiliarDatoLaboralByFecha](DLP.ID, @FechaFin)) AS AsignacionFamiliar
				,((SELECT [ERP].[ObtenerGratificacionDatoLaboralByFecha](DLP.ID, @FechaInicio, @FechaFin)) / 6) AS Gratificacion
				,CASE WHEN CAST(DLP.FechaInicio AS DATE) <  CAST(@FechaInicio AS DATE) THEN
					6
					ELSE
					CAST(DATEDIFF(MONTH, DLP.FechaInicio, @FechaFin) AS INT)
					END AS Mes
					,CASE WHEN CAST(DLP.FechaInicio AS DATE) <  CAST(@FechaInicio AS DATE) THEN
					0
					ELSE
					CAST(DATEDIFF(DAY, DLP.FechaInicio, @FechaFin) AS INT) + 1
					END AS Dias
			FROM ERP.DatoLaboral DLP
			) AS DLP ON DLP.IdDatoLaboral = DL.ID
WHERE DL.IdEmpresa = @IdEmpresa
  AND CAST(DL.FechaInicio AS DATE) <= CAST(@FechaFin AS DATE) 
  AND (DL.FechaCese IS NULL OR CAST(DL.FechaCese AS DATE) <= CAST(@FechaFin AS DATE))

END
