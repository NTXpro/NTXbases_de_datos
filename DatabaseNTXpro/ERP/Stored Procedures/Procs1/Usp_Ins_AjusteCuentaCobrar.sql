
CREATE PROCEDURE [ERP].[Usp_Ins_AjusteCuentaCobrar]
@XMLAjuste	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @IdEmpresa INT = (SELECT TOP 1 T.N.value('IdEmpresa[1]','INT') FROM @XMLAjuste.nodes('/ListaArchivoPlanoAjuste/ArchivoPlanoAjuste') AS T(N));
		DECLARE @UltimoDocumentoGenerado INT= ISNULL((SELECT MAX(Documento) FROM ERP.AjusteCuentaCobrar WHERE IdEmpresa = @IdEmpresa),0);


		INSERT INTO [ERP].[AjusteCuentaCobrar]
		 (
			 IdTipoComprobante
			,IdCuentaCobrar
			,IdEntidad
			,IdMoneda
			,IdEmpresa
			,Fecha
			,Documento
			,Total
			,TipoCambio
			,UsuarioRegistro
			,FechaRegistro
		 )
		SELECT
		T.N.value('IdTipoComprobante[1]','INT')				AS IdTipoComprobante,
		T.N.value('IdCuentaCobrar[1]'	,'INT')				AS IdCuentaCobrar,
		T.N.value('IdEntidad[1]'		,'INT')				AS IdEntidad,
		T.N.value('IdMoneda[1]'			,'INT')				AS IdMoneda,
		T.N.value('IdEmpresa[1]'		,'INT')				AS IdEmpresa,
		T.N.value('Fecha[1]'	   ,'DATETIME')				AS Fecha,
		RIGHT('00000000' + LTRIM(RTRIM(@UltimoDocumentoGenerado + T.N.value('Orden[1]','INT'))), 8) AS Documento,
		T.N.value('Total[1]'		,'DECIMAL(14,5)')		AS Total,
		T.N.value('TipoCambio[1]'	,'DECIMAL(14,5)')		AS TipoCambio,
		T.N.value('UsuarioRegistro[1]'	,'VARCHAR(250)')	AS UsuarioRegistro,
		DATEADD(HOUR, 3, GETDATE())							AS FechaRegistro
		FROM @XMLAjuste.nodes('/ListaArchivoPlanoAjuste/ArchivoPlanoAjuste') AS T(N)	

		SET NOCOUNT OFF;
END
