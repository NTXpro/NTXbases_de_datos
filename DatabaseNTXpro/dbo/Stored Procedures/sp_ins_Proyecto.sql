-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ins_Proyecto]
	-- Add the parameters for the stored procedure here
	@Numero varchar(10),
	@Nombre varchar(250),
	@IDCliente int,
	@FechaInicio datetime,
	@FechaFin datetime,
	@IDMoneda int,
	@igv decimal(14,5),

	@PrecioVenta decimal(14,5),
	@IgvVenta decimal(14,5),
	@TotalVenta decimal(14,5),
	@PrecioCosto decimal(14,5),
	@IgvCosto decimal(14,5),
	@TotalCosto decimal(14,5),
	@Utilidad decimal(14,5),
	@IgvUtilidad decimal(14,5),
	@TotalUtilidad decimal(14,5),
	@PorcentajeUtilidad decimal(14,5),
	@IdEmpresa int,
	@FlagCierre bit,
	@FechaRegistro datetime,

	@PrecioCostoM decimal(14,5),
	@IgvCostoM decimal(14,5),
	@TotalCostoM decimal(14,5),
	@Flag bit,
	@FlagBorrador bit
AS
BEGIN

 -- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET DATEFORMAT ymd
    -- Insert statements for procedure here
	if not exists (select * from erp.Proyecto where  IdEmpresa=@IdEmpresa and Numero=@numero and Flag =1 and FlagBorrador=0) 
		begin
			insert into erp.Proyecto (numero,nombre,idcliente, FechaInicio, FechaFin,IdMoneda,Igv,PresupuestoVenta,IgvVenta,TotalVenta,
			PresupuestoCompra,IgvCompra,TotalCompra,Utilidad,IgvUtilidad,TotalUtilidad,PorcentajeUtilidad,IdEmpresa,FlagCierre,FechaRegistro,
			PresupuestoCompraM,IgvCompraM,TotalCompraM, Flag, FlagBorrador) 
			values (@Numero,@Nombre,@IDCliente,@FechaInicio,@FechaFin,@IDMoneda,@igv,@PrecioVenta,@IgvVenta,@TotalVenta,
			@PrecioCosto,@IgvCosto,@TotalCosto,@Utilidad,@IgvUtilidad,@TotalUtilidad,@PorcentajeUtilidad,@IdEmpresa,@FlagCierre,@FechaRegistro,
			@PrecioCostoM,@IgvCostoM,@TotalCostoM, @Flag,@FlagBorrador)
		end
	else 
		begin
			update erp.Proyecto set nombre=@Nombre,IdCliente=@IDCliente,FechaInicio=@FechaInicio,FechaFin=@FechaFin,IdMoneda=@IDMoneda,
			igv=@igv,PresupuestoVenta=@PrecioVenta,IgvVenta=@IgvVenta,TotalVenta=@TotalVenta,PresupuestoCompra=@PrecioCosto,
			IgvCompra=@IgvCosto,TotalCompra=@TotalCosto,Utilidad=@Utilidad,IgvUtilidad=@IgvUtilidad,TotalUtilidad=@TotalUtilidad,
			PorcentajeUtilidad=@PorcentajeUtilidad,FlagCierre=@FlagCierre,FechaModificado=@FechaRegistro, PresupuestoCompraM=@PrecioCostoM,IgvCompraM=@IgvCostoM,TotalCompraM=@TotalCostoM
			where  IdEmpresa=@IdEmpresa and Numero=@numero and Flag =1 and FlagBorrador=0
		end
END