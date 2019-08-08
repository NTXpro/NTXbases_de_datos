-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Ajustes]
	-- Add the parameters for the stored procedure here
	@IdCuentaCobrar int,
	@Fecha datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select	iif(AjusteSolesAñoAnterior is null,0,AjusteSolesAñoAnterior)  as AjusteSolesAñoAnterior_,
		iif(AjusteSolesAñoPresente is null,0,AjusteSolesAñoPresente)  as AjusteSolesAñoPresente_,
		iif(AjusteDolaresAñoAnterior is null,0,AjusteDolaresAñoAnterior)  as AjusteDolaresAñoAnterior_,
		iif(AjusteAñoDolaresPresente is null,0,AjusteAñoDolaresPresente)  as AjusteAñoDolaresPresente_
from(
select 
	sum(iif( year(B.Fecha)<= datepart(year,@Fecha)-1,B.AjusteSoles,0) )as AjusteSolesAñoAnterior,
	sum(iif( year(B.Fecha)= datepart(year,@Fecha),B.AjusteSoles,0) )as AjusteSolesAñoPresente,
	sum(iif( year(B.Fecha)<= datepart(year,@Fecha)-1,B.AjusteDolares,0) )as AjusteDolaresAñoAnterior,
	sum(iif( year(B.Fecha)= datepart(year,@Fecha),B.AjusteDolares,0) )as AjusteAñoDolaresPresente
from (
SELECT AjusteSoles =(CASE WHEN A.IdMoneda = 1  THEN
			 A.Total
		WHEN A.IdMoneda = 2 THEN
			ROUND((A.Total * A.TipoCambio),2)
		END) ,

		AjusteDolares =(CASE WHEN A.IdMoneda = 2  THEN
			 A.Total
		WHEN A.IdMoneda = 1 THEN
			ROUND((A.Total / A.TipoCambio),2)
		END), A.fecha
FROM ERP.AjusteCuentaCobrar A
WHERE A.IdCuentaCobrar = @IdCuentaCobrar AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE)) as B) as C
END