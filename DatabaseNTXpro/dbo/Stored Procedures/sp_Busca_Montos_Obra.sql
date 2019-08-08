-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Montos_Obra]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int,
	@Numero varchar(10),
	@Fecha datetime
AS
BEGIN
	SET DATEFORMAT ymd
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		select a.idmoneda, a.PresupuestoVenta, a.PresupuestoCompra, a.Utilidad,
	iif(C.CodigoSunat='PEN',PresupuestoVenta,PresupuestoVenta*B.comprasunat) as PresupuestoVentasoles,
	iif(C.CodigoSunat='USD',PresupuestoVenta,PresupuestoVenta/B.comprasunat) as PresupuestoVentaDolares,
	iif(C.CodigoSunat='PEN',PresupuestoCompra,PresupuestoCompra*B.comprasunat) as PresupuestoComprasoles,
	iif(C.CodigoSunat='USD',PresupuestoCompra,PresupuestoCompra/B.comprasunat) as PresupuestoCompraDolares,
	iif(C.CodigoSunat='PEN',Utilidad,Utilidad*B.comprasunat) as Utilidadsoles,
	iif(C.CodigoSunat='USD',Utilidad,Utilidad/B.comprasunat) as UtilidadDolares, a.porcentajeUtilidad,
	iif(C.CodigoSunat='PEN',PresupuestoCompraM,PresupuestoCompraM*B.comprasunat) as PresupuestoCompraMsoles,
	iif(C.CodigoSunat='USD',PresupuestoCompraM,PresupuestoCompraM/B.comprasunat) as PresupuestoCompraMDolares
	from erp.Proyecto as A inner join erp.TipoCambioDiario as B on CAST(A.FechaRegistro as date)= cast(B.Fecha as date) 
	inner join Maestro.Moneda as C on a.idmoneda=C.id  
	where IdEmpresa=@IdEmpresa and 	numero= @Numero and cast(A.FechaRegistro as date)<= @Fecha and flag =1 and flagborrador=0

	/* select a.idmoneda, a.PresupuestoVenta, a.PresupuestoCompra, a.Utilidad, 
	iif(a.idmoneda=1,PresupuestoVenta,PresupuestoVenta*B.comprasunat) as PresupuestoVentasoles,
	iif(a.idmoneda=2,PresupuestoVenta,PresupuestoVenta/B.comprasunat) as PresupuestoVentaDolares,
	iif(a.idmoneda=1,PresupuestoCompra,PresupuestoCompra*B.comprasunat) as PresupuestoComprasoles,
	iif(a.idmoneda=2,PresupuestoCompra,PresupuestoCompra/B.comprasunat) as PresupuestoCompraDolares,
	iif(a.idmoneda=1,Utilidad,Utilidad*B.comprasunat) as Utilidadsoles,
	iif(a.idmoneda=2,Utilidad,Utilidad/B.comprasunat) as UtilidadDolares, a.porcentajeUtilidad
	from erp.Proyecto as A inner join erp.TipoCambioDiario as B on CAST(A.FechaRegistro as date)= cast(B.Fecha as date)
	where IdEmpresa=@IdEmpresa and numero= @Numero and cast(A.FechaRegistro as date)<= @Fecha */
END