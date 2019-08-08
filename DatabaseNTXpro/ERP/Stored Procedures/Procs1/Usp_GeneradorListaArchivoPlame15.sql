-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 13-3-2019
-- Description:	GENERADOR PARA ARCHIVO PLAME 07 PRESTADOR DE SRRVICIOS CON RENTAS DE CUARTA CATEGORIA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_GeneradorListaArchivoPlame15] 
@IdMes int,
@IdAnio int ,
@IdEmpresa int 

AS
BEGIN
DECLARE @Periodo int = 0
DECLARE @RUC AS varchar(20)




SELECT @RUC =etd.NumeroDocumento FROM ERP.Empresa e 
INNER JOIN ERP.Entidad e2 ON e.IdEntidad = e2.ID 
INNER JOIN ERP.EntidadTipoDocumento etd ON e2.ID = etd.IdEntidad
WHERE e.id = @IdEmpresa



DECLARE @FechaInicial varchar(20) 
DECLARE @FechaFinal varchar(20) 

SET    @FechaInicial = cast(@IdAnio AS varchar(20))+'-' +CASE when  LEN(@IdMes)= 1 then '0' else '' end +cast(@IdMes AS varchar(20))+ '-01'
SELECT @FechaFinal =cast( eomonth(@FechaInicial) AS varchar(20))


SELECT @Periodo = p.id FROM ERP.Periodo p 
INNER JOIN Maestro.Anio a ON p.IdAnio = a.ID 
WHERE a.Nombre =@IdAnio AND  p.IdMes =@IdMes

 SELECT 
'0601' +cast(@IdAnio AS varchar(20))+CASE when  LEN(@IdMes)= 1 then '0' else '' end +cast(@IdMes AS varchar(20))+ @RUC + '.snl' AS nombreArchivo
,B.TipoDocumento  +'|'+ B.nrodocumento +'|'+ cast(B.CodigoSunat AS varchar(20)) + '|'+ cast(B.dias AS varchar(20)) AS texto

 FROM (
SELECT 
A.TipoDocumento, A.nrodocumento,
 A.IdDatoLaboral, A.CodigoSunat,sum(A.dias) AS dias FROM 
(SELECT 
	dls.IdDatoLaboral
	,ts.CodigoSunat
	, datediff(day, dls.FechaInicio,dls.FechaFin) AS dias  
	,CASE when  LEN(etd.IdTipoDocumento)= 1 then '0' else '' end +cast(etd.IdTipoDocumento AS varchar(20)) AS TipoDocumento
    ,cast(etd.NumeroDocumento AS varchar(15)) AS nrodocumento
FROM ERP.DatoLaboralSuspension dls
INNER JOIN ERP.DatoLaboral dl ON dls.IdDatoLaboral = dl.ID
INNER JOIN erp.Trabajador t ON dl.IdTrabajador  = t.ID
INNER JOIN ERP.Entidad e ON t.IdEntidad = e.ID
INNER JOIN ERP.Persona p ON e.id = p.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento etd ON e.ID = etd.IdEntidad
INNER JOIN  PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
INNER JOIN PLAME.T21TipoSuspension ts ON dls.IdTipoSuspension = ts.ID
WHERE dls.FechaInicio >= @FechaInicial and dls.FechaFin  <= @FechaFinal AND dl.IdEmpresa = @IdEmpresa) A GROUP BY  A.TipoDocumento, A.nrodocumento,A.CodigoSunat, A.IdDatoLaboral) B
END