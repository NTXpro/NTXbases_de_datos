-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Tesoreria]
	-- Add the parameters for the stored procedure here
	@idCuentaCobrar int,
	@sw int,
	@fecha datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
if @sw=1  -- soles
  begin
		select
		 iif(EE.cobradoAñoAnterior is null,0,EE.cobradoAñoAnterior) as cobradoAñoAnterior_,
		 iif(EE.cobradoAñoPresente is null,0,EE.cobradoAñoPresente) as cobradoAñoPresente_
		from ( 
		select sum(iif( year(DD.Fecha)<= datepart(year,@Fecha)-1,DD.Total,0) )as cobradoAñoAnterior,
		sum(iif( year(DD.Fecha)= datepart(year,@Fecha),DD.Total,0)) as cobradoAñoPresente
		from (SELECT Total = CASE 
					WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 1 THEN 	
							MTD.Total    
					WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 1 THEN 	
							ROUND((MTD.Total * MT.TipoCambio),2)  
					END	, MT.Fecha
			FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
			INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
			INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
			INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
			WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.FlagBorrador = 0 
			AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)) as DD) as EE
	end
else
	begin
		select sum(iif( year(DD.Fecha)<= datepart(year,@Fecha)-1,DD.Total,0) )as cobradoAñoAnterior,
		sum(iif( year(DD.Fecha)= datepart(year,@Fecha),DD.Total,0)) as cobradoAñoPresente
		from (SELECT Total = CASE 
					WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 2 THEN 	
							MTD.Total    
					WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 2 THEN 	
							ROUND((MTD.Total / MT.TipoCambio),2)  
					END	, MT.Fecha
			FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
			INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
			INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
			INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
			WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.FlagBorrador = 0 
			AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)) as DD

	end
END