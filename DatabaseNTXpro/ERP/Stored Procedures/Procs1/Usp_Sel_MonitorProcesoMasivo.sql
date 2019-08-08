-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 14/09/2018
-- Description:	CONSULTA DE LOS RESULTADOS DE PROCESOS MASIVOS
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_MonitorProcesoMasivo]
	-- Add the parameters for the stored procedure here
    @PROCESO nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON --added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT 
       mpm.Descripcion
	FROM ERP.MonitorProcesoMasivo mpm WHERE mpm.Proceso=@PROCESO
END