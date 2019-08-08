-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 13-3-2019
-- Description:	GENERADOR PARA ARCHIVO PLAME 07 PRESTADOR DE SRRVICIOS CON RENTAS DE CUARTA CATEGORIA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_GeneradorListaArchivoPlame07] 
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

SELECT @Periodo = p.id FROM ERP.Periodo p 
INNER JOIN Maestro.Anio a ON p.IdAnio = a.ID 
WHERE a.Nombre =@IdAnio AND  p.IdMes =@IdMes

 SELECT DISTINCT A.nombreArchivo, (A.CodigoSunat+'|'+ A.nrodocumento+'|'+  A.ApellidoPaterno+'|'+  A.ApellidoMaterno+'|'+  A.Nombre+'|'+ A.Domiciliado+'|'+  A.Convenio) AS texto FROM 
(SELECT
  mt.IdEmpresa,e.id,
  '0601' +cast(@IdAnio AS varchar(20))+CASE when  LEN(@IdMes)= 1 then '0' else '' end +cast(@IdMes AS varchar(20))+ @RUC + '.ps4' AS nombreArchivo, 
  RTRIM(td.CodigoSunat) AS CodigoSunat, 
  cast(etd.NumeroDocumento AS varchar(15)) AS nrodocumento,
  isnull(p.ApellidoPaterno,'') AS ApellidoPaterno, isnull(p.ApellidoMaterno,'') AS ApellidoMaterno, isnull(p.Nombre,'N/A') AS Nombre, '1' AS Domiciliado,
  '0' AS Convenio
  FROM ERP.MovimientoTesoreria mt
	INNER JOIN ERP.MovimientoTesoreriaDetalle mtd ON mt.ID = mtd.IdMovimientoTesoreria 
	INNER JOIN ERP.Entidad e ON mtd.IdEntidad = e.ID
	INNER JOIN ERP.Persona p ON e.id = p.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento etd ON e.ID = etd.IdEntidad
	INNER JOIN  PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
 WHERE mt.IdPeriodo =@Periodo AND mtd.IdTipoComprobante = 3  AND mt.IdEmpresa = @IdEmpresa) A
END