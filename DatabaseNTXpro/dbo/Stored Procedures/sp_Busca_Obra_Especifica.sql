-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Obra_Especifica] 
	-- Add the parameters for the stored procedure here
	@IdEmpresa int,
	@Numero varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ERP.Proyecto.ID,  ERP.Proyecto.Numero, ERP.Proyecto.Nombre as nombreProyecto, ERP.Proyecto.IdCliente, 
	ERP.Entidad.Nombre as nombreCliente, ERP.Proyecto.FechaInicio, ERP.Proyecto.FechaFin, 
	iif(ERP.Proyecto.IdMoneda=1,0,1) as Pos, ERP.Proyecto.Igv, ERP.Proyecto.PresupuestoVenta, 
	ERP.Proyecto.IgvVenta, ERP.Proyecto.TotalVenta, ERP.Proyecto.PresupuestoCompra, 
	ERP.Proyecto.IgvCompra, ERP.Proyecto.TotalCompra, ERP.Proyecto.Utilidad, 
	ERP.Proyecto.IgvUtilidad, ERP.Proyecto.TotalUtilidad, ERP.Proyecto.PorcentajeUtilidad, 
	ERP.Proyecto.FlagCierre, ERP.Proyecto.PresupuestoCompraM,ERP.Proyecto.IgvCompraM, ERP.Proyecto.TotalCompraM,erp.proyecto.FechaRegistro
	FROM (ERP.Proyecto INNER JOIN ERP.Cliente ON ERP.Proyecto.IdCliente = ERP.Cliente.ID) 
	INNER JOIN ERP.Entidad ON ERP.Cliente.IdEntidad = ERP.Entidad.ID
	WHERE (((ERP.Proyecto.IdEmpresa)=@IdEmpresa) AND ((ERP.Proyecto.Numero)=@Numero) AND ERP.Proyecto.Flag=1 AND ERP.Proyecto.FlagBorrador=0);

END