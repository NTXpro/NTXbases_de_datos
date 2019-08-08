-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Contabilidad
	-- Add the parameters for the stored procedure here
	@IdEmpresa int,
	@IdProyecto int,
	@Fecha datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select 
iif(C.GastadoSolesAñoAnterior is null, 0, C.GastadoSolesAñoAnterior) as GastadoSolesAñoAnterior_,
iif(C.GastadoSolesAñoPresente is null, 0, C.GastadoSolesAñoPresente) as GastadoSolesAñoPresente_,
iif(C.GastadoDolaresAñoAnterior is null,0, C.GastadoDolaresAñoAnterior) as GastadoDolaresAñoAnterior_,
iif(C.GastadoDolaresAñoPresente is null,0, C.GastadoDolaresAñoPresente) as GastadoDolaresAñoPresente_
from (
select 
-- A.origen, A.Nombre, A.Fecha, A.CuentaContable, A.Documento,
sum(iif(year(A.Fecha) <= datepart(year,@Fecha)-1 ,A.ImporteSoles,0)) as GastadoSolesAñoAnterior, 
sum(iif(year(A.Fecha) = datepart(year,@Fecha) ,A.ImporteSoles,0)) as GastadoSolesAñoPresente,
sum(iif(year(A.Fecha) <= datepart(year,@Fecha)-1 ,A.ImporteDolares,0)) as GastadoDolaresAñoAnterior,
sum(iif(year(A.Fecha) = datepart(year,@Fecha) ,A.ImporteDolares,0)) as GastadoDolaresAñoPresente
from (
SELECT 'Contabilidad' AS origen, ERP.Asiento.IdOrigen,  
ERP.AsientoDetalle.Nombre, ERP.Asiento.Fecha, ERP.PlanCuenta.CuentaContable, ERP.AsientoDetalle.Serie, 
ERP.AsientoDetalle.Documento, ERP.Asiento.IdMoneda, ERP.Asiento.TipoCambio, ERP.AsientoDetalle.ImporteSoles, 
ERP.AsientoDetalle.ImporteDolares
FROM ((ERP.Asiento 
INNER JOIN ERP.AsientoDetalle ON ERP.Asiento.ID = ERP.AsientoDetalle.IdAsiento) 
INNER JOIN ERP.PlanCuenta ON (ERP.AsientoDetalle.IdPlanCuenta = ERP.PlanCuenta.ID) AND (ERP.AsientoDetalle.IdPlanCuenta = ERP.PlanCuenta.ID)) 
INNER JOIN Maestro.Origen ON ERP.Asiento.IdOrigen = Maestro.Origen.ID
WHERE 
(((ERP.Asiento.Fecha)<=@Fecha) AND 
((ERP.AsientoDetalle.IdProyecto)=@IdProyecto) AND 
((ERP.Asiento.IdEmpresa)=@IdEmpresa) AND 
((ERP.Asiento.Flag)=1) AND 
((ERP.Asiento.FlagBorrador)=0) AND
left(ERP.PlanCuenta.CuentaContable,1)='9' and 
Maestro.Origen.Abreviatura in('01','09','17','18','19','21'))) as A) as C
-- 01 asientos de diario, 09 planilla, 17 regularizaciones, 18 provisiones, 19 provision rrhh, 21 proveedores

END