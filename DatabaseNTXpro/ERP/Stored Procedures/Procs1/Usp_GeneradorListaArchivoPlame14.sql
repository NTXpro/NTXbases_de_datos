-----

-- Stored Procedure

-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 13-3-2019
-- Description:	GENERADOR PARA ARCHIVO PLAME 07 PRESTADOR DE SRRVICIOS CON RENTAS DE CUARTA CATEGORIA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_GeneradorListaArchivoPlame14] 
@IdMes int,
@IdAnio int ,
@IdEmpresa int 

AS
BEGIN
DECLARE @RUC AS varchar(20)


DECLARE @FechaInicial varchar(20) 
DECLARE @FechaFinal varchar(20) 

SET    @FechaInicial = cast(@IdAnio AS varchar(20))+'-' +CASE when  LEN(@IdMes)= 1 then '0' else '' end +cast(@IdMes AS varchar(20))+ '-01'
SELECT @FechaFinal =cast( eomonth(@FechaInicial) AS varchar(20))

SELECT @RUC =etd.NumeroDocumento FROM ERP.Empresa e 
INNER JOIN ERP.Entidad e2 ON e.IdEntidad = e2.ID 
INNER JOIN ERP.EntidadTipoDocumento etd ON e2.ID = etd.IdEntidad
WHERE e.id = @IdEmpresa


SELECT 
'0601' +cast(@IdAnio AS varchar(20))+CASE when  LEN(@IdMes)= 1 then '0' else '' end +cast(@IdMes AS varchar(20))+ @RUC + '.jor' AS nombreArchivo
 ,A.TipoDocumento +'|'+ A.nrodocumento +'|'+ cast(sum(A.HoraOrdinaria) AS varchar(20)) + '|0|'+ cast(sum(A.HoraExtra)AS varchar(20)) +'|0|' AS texto
 FROM 
(SELECT 
  pc.ID
  ,CASE when  LEN(etd.IdTipoDocumento)= 1 then '0' else '' end +cast(etd.IdTipoDocumento AS varchar(20)) AS TipoDocumento
  ,cast(etd.NumeroDocumento AS varchar(15)) AS nrodocumento
  ,(SELECT cast(sum(pp.Calculo)  as int) horaExtra FROM ERP.PlanillaPago pp WHERE pp.IdPlanillaCabecera = pc.id AND pp.IdConcepto in(32,33,34,35)) AS HoraExtra
  ,(SELECT cast(sum(pht.HoraPorcentaje)  as int) horaOrdinaria FROM ERP.PlanillaHojaTrabajo pht  WHERE pht.IdPlanillaCabecera = pc.id AND pht.IdConcepto in(1)) AS HoraOrdinaria
  FROM ERP.PlanillaCabecera pc 
    INNER JOIN erp.Trabajador t ON pc.IdTrabajador = t.ID
	INNER JOIN ERP.Entidad e ON t.IdEntidad = e.ID
	INNER JOIN ERP.Persona p ON e.id = p.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento etd ON e.ID = etd.IdEntidad
	INNER JOIN  PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
 WHERE pc.IdEmpresa = @IdEmpresa AND pc.FechaIniPlanilla >= @FechaInicial AND  pc.FechaFinPlanilla <=@FechaFinal) A
 GROUP BY  A.TipoDocumento , A.nrodocumento

END