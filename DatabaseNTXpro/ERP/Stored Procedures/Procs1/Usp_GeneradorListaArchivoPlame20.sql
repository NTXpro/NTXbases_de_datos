-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 13-3-2019
-- Description:	GENERADOR PARA ARCHIVO PLAME 20 PRESTADOR DE SRRVICIOS CON RENTAS DE CUARTA CATEGORIA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_GeneradorListaArchivoPlame20] 
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



 SELECT DISTINCT A.nombreArchivo, (
 
				 A.CodigoSunat+'|'+ 
				 A.nrodocumento+'|'+  
				 A.ApellidoPaterno+'|'+  
				 A.ApellidoMaterno+'|'+  
				 A.Nombre+'|'+ 
				 A.Domiciliado+'|'+  
				 A.Convenio +'|'+ 
				 A.IdTipoMovimientoTemp   +'|'+   
				 A.Serie  +'|'+ 
				 A.Documento    +'|'+  
				 A.total   +'|'+  
				 A.fechaEmision   +'|'+ 
				 A.fechapago    +'|'+  
				 A.indicadorRetencion +'|'+ 
				 A.indicadorRegimen  +'||'
				 ) AS texto
  -- A.IdTipoMovimiento 
 --,A.Serie
 --,A.Documento
 --,A.total
 --,A.fechaemision
 --,A.fechapago
 --,A.indicadorRetencion
 --,A.indicadorRegimen
 --,A.ImporteAlRegimen

 FROM 
(SELECT
  mt.IdEmpresa,e.id,
  '0601' +cast(@IdAnio AS varchar(20))+CASE when  LEN(@IdMes)= 1 then '0' else '' end +cast(@IdMes AS varchar(20))+ @RUC + '.4ta' AS nombreArchivo, 
  RTRIM(td.CodigoSunat) AS CodigoSunat, 
  cast(etd.NumeroDocumento AS varchar(15)) AS nrodocumento,
  isnull(p.ApellidoPaterno,'') AS ApellidoPaterno, isnull(p.ApellidoMaterno,'') AS ApellidoMaterno, isnull(p.Nombre,'N/A') AS Nombre, '1' AS Domiciliado,
  '0' AS Convenio
   ,'R' as IdTipoMovimientoTemp-- ,mt.IdTipoMovimiento
  ,cast(mtd.Serie AS varchar(20)) AS Serie
  ,cast( mtd.Documento AS varchar(20)) AS Documento
 -- ,registro compra y ver si tiene o no impuesto 
 , (SELECT TOP 1 CASE WHEN c.Inafecto = c.Total THEN '1' ELSE '0' END IndicadorRetencion FROM  erp.Compra c WHERE c.Serie = mtd.Serie AND c.Numero = mtd.Documento AND c.IdEmpresa =@IdEmpresa) AS indicadorRetencion
  ,cast(cast(mtd.Total AS numeric(12,2)) AS varchar(20)) as total
  ,CASE when  LEN(day(mt.Fecha))= 1 then '0' else '' end +  (cast(day(mt.Fecha) AS varchar(10)) + '/'+CASE when  LEN(month(mt.Fecha))= 1 then '0' else '' end + cast(month(mt.Fecha) AS varchar(10))+ '/' + cast(year(mt.Fecha) AS varchar(10))) AS fechapago

  ,( SELECT TOP 1 CASE when  LEN(day(c.FechaEmision))= 1 then '0' else '' end +  (cast(day(c.FechaEmision) AS varchar(10)) + '/'+CASE when  LEN(month(c.FechaEmision))= 1 then '0' else '' end 
  + cast(month(c.FechaEmision) AS varchar(10))+ '/' + cast(year(c.FechaEmision) AS varchar(10))) AS fechaemision  FROM  erp.Compra c WHERE c.Serie = 'E001' AND c.Numero = '0000045' AND c.IdEmpresa =@IdEmpresa) AS fechaEmision
  ,'3' AS indicadorRegimen
  ,'' AS ImporteAlRegimen
  FROM ERP.MovimientoTesoreria mt
	INNER JOIN ERP.MovimientoTesoreriaDetalle mtd ON mt.ID = mtd.IdMovimientoTesoreria 
	INNER JOIN ERP.Entidad e ON mtd.IdEntidad = e.ID
	INNER JOIN ERP.Persona p ON e.id = p.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento etd ON e.ID = etd.IdEntidad
	INNER JOIN  PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
	--INNER JOIN ple.T2TipoDocumento td2 ON td2.id = mt.id
 WHERE mt.IdPeriodo =@Periodo AND mtd.IdTipoComprobante = 3  AND mt.IdEmpresa = @IdEmpresa) A
 END