-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Facturado_Cobrado
	-- Add the parameters for the stored procedure here
	@idProyecto int,
	@idEmpresa int,
	@fecha datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ERP.Proyecto.ID, ERP.Proyecto.Nombre, ERP.Proyecto.Numero, ERP.Proyecto.IdEmpresa, 
	ERP.Comprobante.Serie, ERP.Comprobante.Documento, ERP.Comprobante.Fecha, ERP.Comprobante.IdMoneda, 
	ERP.Comprobante.SubTotal, ERP.Comprobante.IGV, ERP.Comprobante.Total, ERP.Comprobante.IdComprobanteEstado, 
	ERP.CuentaCobrar.ID as idCuentaCobrar, ERP.CuentaCobrar.IdMoneda, ERP.CuentaCobrar.Total, ERP.Comprobante.Fecha
	FROM (ERP.Proyecto INNER JOIN ERP.Comprobante ON (ERP.Proyecto.IdEmpresa = ERP.Comprobante.IdEmpresa) AND 
	(ERP.Proyecto.ID = ERP.Comprobante.IdProyecto)) INNER JOIN ERP.CuentaCobrar ON 
	(ERP.Comprobante.IdEmpresa = ERP.CuentaCobrar.IdEmpresa) AND (ERP.Comprobante.Documento = ERP.CuentaCobrar.Numero) AND 
	(ERP.Comprobante.Serie = ERP.CuentaCobrar.Serie)
	WHERE (((ERP.Proyecto.ID)=@idProyecto) AND ((ERP.Proyecto.IdEmpresa)=@idEmpresa) AND 
	((ERP.Comprobante.IdComprobanteEstado)=2) AND 
	(( cast(ERP.Comprobante.Fecha as date))<=@fecha)) 
END