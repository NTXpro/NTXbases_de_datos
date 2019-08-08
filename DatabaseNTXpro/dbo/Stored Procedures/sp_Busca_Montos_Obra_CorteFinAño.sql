-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Montos_Obra_CorteFinAño
	-- Add the parameters for the stored procedure here
	@idEmpresa int,
	@Numero varchar(10),
	@Fecha datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	iif( E.ImporteSoles is null,0,ImporteSoles) as ImporteSoles_,
	iif( E.ImporteDolares is null,0,ImporteDolares) as ImporteDolares_
	from (
	select A.PresupuestoCompraM ,
	iif(C.CodigoSunat='PEN', A.PresupuestoCompraM, A.PresupuestoCompraM*D.VentaSunat) as ImporteSoles,
	iif(C.CodigoSunat='USD', A.PresupuestoCompraM, A.PresupuestoCompraM/D.VentaSunat) as ImporteDolares
	from erp.ProyectoCorteFinAño A inner join erp.Proyecto B on A.Id=B.Id and 
	A.Numero=B.Numero and
	A.idEmpresa=B.idEmpresa
	inner join Maestro.Moneda C on A.idMoneda=C.id
	inner join ERP.TipoCambioDiario D on cast(A.FechaCorte as date) = cast(D.Fecha as date)
	where A.Numero=@Numero and A.idEmpresa=@idEmpresa and cast(A.FechaCorte as date)<=@Fecha) as E
END