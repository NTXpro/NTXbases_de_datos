CREATE PROC [ERP].[Usp_Ins_TipoComprobantePlanCuenta]
@IdEmpresa INT,
@IdTipoComprobante INT,
@IdAnio INT,
@XMLTipoComprobantePlanCuenta XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

			DELETE FROM ERP.TipoComprobantePlanCuenta WHERE IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante and IdAnio = @IdAnio

			INSERT INTO ERP.TipoComprobantePlanCuenta(
														IdEmpresa,
														IdTipoComprobante,
														IdTipoRelacion,
														IdMoneda,
														IdPlanCuenta,
														IdSistema,
														IdAnio,
														Nombre,
														FechaRegistro,
														FlagBorrador,
														Flag,
														FechaModificado,
														UsuarioRegistro,
														UsuarioModifico
														)
	SELECT
		T.N.value('IdEmpresa[1]','INT')						AS IdEmpresa,
		T.N.value('IdTipoComprobante[1]','INT')				AS IdTipoComprobante,
		T.N.value('IdTipoRelacion[1]','INT')				AS IdTipoRelacion,
		T.N.value('IdMoneda[1]','INT')						AS IdMoneda,
		T.N.value('IdPlanCuenta[1]','INT')					AS IdPlanCuenta,
		T.N.value('IdSistema[1]','INT')						AS IdSistema,
		@IdAnio,
		T.N.value('Nombre[1]','VARCHAR(250)')				AS Nombre,
		GETDATE(),
		CAST(0 AS BIT),
		CAST(1 AS BIT),
		GETDATE(),
		T.N.value('UsuarioRegistro[1]'		,'VARCHAR(250)') AS UsuarioRegistro,
		T.N.value('UsuarioRegistro[1]'		,'VARCHAR(250)') AS UsuarioModifico
		FROM @XMLTipoComprobantePlanCuenta.nodes('/ListaArchivoPlanoTipoComprobantePlanCuenta/ArchivoPlanoTipoComprobantePlanCuenta') AS T(N)	


		SET NOCOUNT OFF;
END