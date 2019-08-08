CREATE PROC [ERP].[Usp_Ins_PlanCuentaDestino]
@IdPlanCuentaOrigen INT,
@IdPlanCuentaDestino INT OUT ,
@XMLDestino	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;


		--DECLARE @IdPlanCuentaOrigen INT = (SELECT TOP 1  T.N.value('IdPlanCuentaOrigen[1]',				'INT') FROM @XMLDestino.nodes('/ListaArchivoPlanoPlanCuentaDestino/ArchivoPlanoPlanCuentaDestino') AS T(N))

		DECLARE @COUNT INT = (SELECT COUNT(ID) FROM ERP.PlanCuentaDestino WHERE IdPlanCuentaOrigen = @IdPlanCuentaOrigen)

		IF(@COUNT > 0)
			BEGIN

				DELETE ERP.PlanCuentaDestino WHERE IdPlanCuentaOrigen = @IdPlanCuentaOrigen

			END

		INSERT INTO ERP.PlanCuentaDestino(	IdEmpresa,
											IdPlanCuentaOrigen,
											IdPlanCuentaDestino1,
											IdPlanCuentaDestino2,
											Porcentaje
											)
											SELECT 
											T.N.value('IdEmpresa[1]',				'INT')								AS IdEmpresa,
											T.N.value('IdPlanCuentaOrigen[1]',				'INT')						AS IdPlanCuentaOrigen,
											T.N.value('IdPlanCuentaDestino1[1]',				'INT')					AS IdPlanCuentaDestino1,
											T.N.value('IdPlanCuentaDestino2[1]',				'INT')					AS IdPlanCuentaDestino2,
											T.N.value('Porcentaje[1]',				'DECIMAL(14,5)')					AS Porcentaje
											FROM @XMLDestino.nodes('/ListaArchivoPlanoPlanCuentaDestino/ArchivoPlanoPlanCuentaDestino') AS T(N)

		SET @IdPlanCuentaDestino = ISNULL(SCOPE_IDENTITY(), 0)


		SET NOCOUNT OFF;
END