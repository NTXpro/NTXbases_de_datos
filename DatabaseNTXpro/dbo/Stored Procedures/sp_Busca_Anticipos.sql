-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Anticipos

	-- Add the parameters for the stored procedure here
	@IdCuentaCobrar int,
	@Fecha datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @IdTipoComprobante TABLE (ID INT)

	INSERT INTO @IdTipoComprobante SELECT ID FROM PLE.T10TipoComprobante WHERE ID IN (8,21,55,60,183,178)

	DECLARE @IdTipoComprobanteCuentaCobrar INT = (SELECT IdTipoComprobante FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)

	IF(@IdTipoComprobanteCuentaCobrar IN (SELECT ID FROM @IdTipoComprobante))
		BEGIN
				
				Select 
				iif(B.TotalAplicadoAñoAnterior is null,0,B.TotalAplicadoAñoAnterior) as TotalAplicadoAñoAnterior_,
				iif (B.TotalAplicadoAñoPresente is null,0,B.TotalAplicadoAñoPresente) as TotalAplicadoAñoPresente_
				from (
				select 
					sum(iif( year(A.FechaRegistro)<= datepart(year,@Fecha)-1,A.TotalAplicado,0) )  as TotalAplicadoAñoAnterior,
					sum(iif( year(A.FechaRegistro)= datepart(year,@Fecha),A.TotalAplicado,0) )as TotalAplicadoAñoPresente
				from(
				SELECT AACD.TotalAplicado,AAC.FechaRegistro 
				  FROM ERP.AplicacionAnticipoCobrar AAC
				  INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACD ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
				  INNER JOIN ERP.CuentaCobrar	CC ON CC.ID = AAC.IdCuentaCobrar
				  WHERE CC.ID = @IdCuentaCobrar 
				 AND CAST(AAC.FechaRegistro AS DATE) <= CAST(@Fecha AS DATE)) as A) as B
		END
	ELSE
		BEGIN
				
				Select 
				iif(TotalAplicadoAñoAnterior is null,0,TotalAplicadoAñoAnterior) as TotalAplicadoAñoAnterior_,
				iif (TotalAplicadoAñoPresente is null,0,TotalAplicadoAñoPresente) as TotalAplicadoAñoPresente_
				from (
				select 
					sum(iif( year(A.FechaRegistro)<= datepart(year,@Fecha)-1,A.TotalAplicado,0) )  as TotalAplicadoAñoAnterior,
					sum(iif( year(A.FechaRegistro)= datepart(year,@Fecha),A.TotalAplicado,0) )as TotalAplicadoAñoPresente
				from (
				 SELECT TotalAplicado = (CASE 
												WHEN AAC.IdMoneda = 1 AND CC.IdMoneda = 1 THEN
														AACD.TotalAplicado
												WHEN AAC.IdMoneda = 2 AND CC.IdMoneda = 1 THEN
														ROUND((AACD.TotalAplicado * AAC.TipoCambio),2)
												END	),
						AAC.FechaRegistro
				  FROM ERP.AplicacionAnticipoCobrar AAC
					INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACD ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
					INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AACD.IdCuentaCobrar
					WHERE CC.ID = @IdCuentaCobrar AND CAST(AAC.FechaRegistro AS DATE) <= CAST(@Fecha AS DATE)) as A) as B
					
		
		END
END