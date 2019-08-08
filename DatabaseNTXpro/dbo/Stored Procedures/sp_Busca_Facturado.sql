-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Facturado]
	-- Add the parameters for the stored procedure here
@idProyecto int,
	@idempresa int,
	@Fecha Datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
iif(C.FacturadoAnteriorTotalSoles is null,0,C.FacturadoAnteriorTotalSoles) as FacturadoAnteriorTotalSoles_,
iif(C.FacturadoPresenteTotalSoles is null,0,C.FacturadoPresenteTotalSoles) as FacturadoPresenteTotalSoles_,
iif(C.FacturadoAnteriorTotalDolares is null,0,C.FacturadoAnteriorTotalDolares) as FacturadoAnteriorTotalDolares_,
iif(C.FacturadoPresenteTotalDolares is null,0,C.FacturadoPresenteTotalDolares) as FacturadoPresenteTotalDolares_
from (
	SELECT
	sum(iif(B.año <= datepart(year,@Fecha)-1 ,B.TotalVentaSoles,0)) as FacturadoAnteriorTotalSoles, 
	sum(iif(B.año = datepart(year,@Fecha), B.TotalVentaSoles,0)) as FacturadoPresenteTotalSoles,
	sum(iif(B.año <=datepart(year,@Fecha)-1, B.TotalVentaDolares,0)) as FacturadoAnteriorTotalDolares, 
	sum(iif(B.año = datepart(year,@Fecha), B.TotalVentaDolares,0)) as FacturadoPresenteTotalDolares
	FROM (SELECT A.Nombre, A.Serie, A.Documento, A.Fecha, 
	(IIf(A.CodigoSunat='07',A.VentaSoles*-1,A.VentaSoles)) AS TotalVentaSoles, 
	IIf(A.CodigoSunat='07',A.VentaDolares*-1,A.VentaDolares) AS TotalVentaDolares, A.año
	FROM (SELECT PLE.T10TipoComprobante.Nombre, ERP.Comprobante.Serie, ERP.Comprobante.Documento, ERP.Comprobante.Fecha, 
	year( ERP.Comprobante.Fecha)as año, ERP.Comprobante.IdMoneda, ERP.Comprobante.SubTotal, ERP.Comprobante.IdTipoComprobante, 
	PLE.T10TipoComprobante.CodigoSunat, ERP.TipoCambioDiario.VentaSunat,
	iif( ERP.Comprobante.IdMoneda=1, ERP.Comprobante.SubTotal,ERP.Comprobante.SubTotal* ERP.TipoCambioDiario.VentaSunat) as VentaSoles,
	iif( ERP.Comprobante.IdMoneda=2, ERP.Comprobante.SubTotal,ERP.Comprobante.SubTotal/ ERP.TipoCambioDiario.VentaSunat) as VentaDolares
	FROM (ERP.Comprobante INNER JOIN PLE.T10TipoComprobante ON ERP.Comprobante.IdTipoComprobante = PLE.T10TipoComprobante.ID) 
	INNER JOIN ERP.TipoCambioDiario ON ERP.Comprobante.Fecha = ERP.TipoCambioDiario.Fecha
	WHERE (((ERP.Comprobante.IdEmpresa)=@idempresa) AND ERP.Comprobante.IdComprobanteEstado=2
	AND ((ERP.Comprobante.IdProyecto)=@idproyecto)) 
	and cast(ERP.Comprobante.Fecha as date)<=@Fecha)  AS A)  AS B) as C
END