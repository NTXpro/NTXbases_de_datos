CREATE PROC [ERP].[Usp_Sel_Correlativo_ResumenDiario]
@Fecha DATETIME,
@IdEmpresa INT
as
begin
	DECLARE @Count INT = (SELECT COUNT(Correlativo) FROM ERP.ResumenDiario WHERE CAST(FechaEnvio AS DATE) = CAST(@Fecha AS DATE) AND IdEmpresa = @IdEmpresa)
	
	SELECT CAST((ISNULL(@Count,0) + 1) AS VARCHAR(3))
end
