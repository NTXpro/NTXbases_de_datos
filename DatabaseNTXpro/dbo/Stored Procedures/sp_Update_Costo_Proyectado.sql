-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Costo_Proyectado]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int,
	@Numero varchar(10),
	@PrecioCostoM decimal(14,5),
	@igv  decimal(14,5)
AS
BEGIN
	Declare @IgvCostoM decimal(14,5)
	Declare @TotalCostoM decimal(14,5)

	set @IgvCostoM=@PrecioCostoM*@igv
	set @TotalCostoM= @PrecioCostoM + @IgvCostoM

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update erp.Proyecto set 
			PresupuestoCompraM=@PrecioCostoM,
			IgvCompraM=@IgvCostoM,
			TotalCompraM=@TotalCostoM
		where  IdEmpresa=@IdEmpresa and Numero=@numero and  Flag=1 AND FlagBorrador=0
	
END