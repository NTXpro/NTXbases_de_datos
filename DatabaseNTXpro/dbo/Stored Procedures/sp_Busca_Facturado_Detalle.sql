-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Facturado_Detalle
	-- Add the parameters for the stored procedure here
	@IdProyecto int,
	@IdEmpresa int,
	@Fecha as Datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT A.Nombre, A.Serie, A.Documento, A.Fecha, IIf(A.CodigoSunat='07',A.VentaSoles*-1,A.VentaSoles) AS TotalVentaSoles, 
	IIf(A.CodigoSunat='07',A.VentaDolares*-1,A.VentaDolares) AS TotalVentaDolares, A.año
	FROM (SELECT PLE.T10TipoComprobante.Nombre, ERP.Comprobante.Serie, ERP.Comprobante.Documento, ERP.Comprobante.Fecha, 
	year( ERP.Comprobante.Fecha)as año, ERP.Comprobante.IdMoneda, ERP.Comprobante.SubTotal, ERP.Comprobante.IdTipoComprobante, 
	PLE.T10TipoComprobante.CodigoSunat, ERP.TipoCambioDiario.VentaSunat,
	iif( ERP.Comprobante.IdMoneda=1, ERP.Comprobante.SubTotal,ERP.Comprobante.SubTotal* ERP.TipoCambioDiario.VentaSunat) as VentaSoles,
	iif( ERP.Comprobante.IdMoneda=2, ERP.Comprobante.SubTotal,ERP.Comprobante.SubTotal/ ERP.TipoCambioDiario.VentaSunat) as VentaDolares
	FROM (ERP.Comprobante INNER JOIN PLE.T10TipoComprobante ON ERP.Comprobante.IdTipoComprobante = PLE.T10TipoComprobante.ID) 
	INNER JOIN ERP.TipoCambioDiario ON ERP.Comprobante.Fecha = ERP.TipoCambioDiario.Fecha
	WHERE (((ERP.Comprobante.IdEmpresa)=@IdEmpresa) AND ERP.Comprobante.IdComprobanteEstado=2 AND ((ERP.Comprobante.IdProyecto)=@IdProyecto)) and cast(ERP.Comprobante.Fecha as date)<=@Fecha)  AS A
	ORDER BY A.Nombre, A.Serie, A.Documento, A.Fecha

END