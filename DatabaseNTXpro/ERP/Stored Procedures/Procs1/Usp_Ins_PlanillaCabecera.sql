-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 10/12/2018
-- Description:	INSERTA CABECERA PLANILLA AL MOMENTO DE GUARDAR LOS REGISTROS EN LA PLANILLA CALCULO
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Ins_PlanillaCabecera]
	@IdEmpresa int,
    @IdPlanilla int,
    @IdTrabajador int,
    @FechaInicio datetime,
    @FechaFin datetime,
	@IdAnio int,
	@IdMes int,
	@IdDatoLaboralDetalle int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @IdPeriodo int =(SELECT TOP 1 p.ID FROM ERP.Periodo p WHERE  p.IdMes = @IdMes AND p.IdAnio = @IdAnio)

	 DECLARE  @Orden int =1+ (SELECT count(ID) FROM ERP.PlanillaCabecera pc
	               WHERE pc.IdEmpresa = @IdEmpresa AND pc.IdPlanilla =@IdPlanilla AND pc.FechaInicio= @FechaInicio AND pc.FechaFin= @FechaFin)
    -- Insert statements for procedure here
	INSERT ERP.PlanillaCabecera
(
    --ID - this column value is auto-generated
    IdEmpresa,
    IdPeriodo,
    IdPlanilla,
    IdTrabajador,
    FechaInicio,
    FechaFin,
    Orden,
    CodigoProceso,
    TotalIngreso,
    TotalDescuentos,
    TotalAportes,
    NetoAPagar,
	IdDatoLaboralDetalle
)
VALUES
(
    @IdEmpresa ,
    @IdPeriodo ,
    @IdPlanilla ,
    @IdTrabajador ,
    @FechaInicio ,
    @FechaFin ,
    @Orden ,
    '' ,
    0 ,
    0 ,
    0 ,
	0,
	@IdDatoLaboralDetalle
)
SELECT @@IDENTITY AS ID
END