

create PROCEDURE [ERP].[Usp_Upd_CTS_Reprocesar]
@IdCTS	 INT,
@XMLCTS	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		DELETE FROM [ERP].[CTSDetalle] WHERE IdCTS = @IdCTS;

		INSERT INTO [ERP].[CTSDetalle]
		 (
			IdCTS
			,IdDatoLaboral
			,Sueldo
			,AsignacionFamiliar
			,Bonificacion
			,HE25
			,HE35
			,HE100
			,Comision
			,Remuneracion
			,Mes
			,ValorMes
			,ImporteMes
			,Dias
			,ValorDia
			,ImporteDia
			,TotalCTS
		 )
		SELECT
		@IdCTS										AS IdCTS,
		T.N.value('IdDatoLaboral[1]','INT')						AS IdDatoLaboral,
		T.N.value('Sueldo[1]','DECIMAL(14,5)')					AS Sueldo,
		T.N.value('AsignacionFamiliar[1]','DECIMAL(14,5)')		AS AsignacionFamiliar,
		T.N.value('Bonificacion[1]'	,'DECIMAL(14,5)')			AS Bonificacion,
		T.N.value('HE25[1]'	,'DECIMAL(14,5)')					AS HE25,
		T.N.value('HE35[1]'	,'DECIMAL(14,5)')					AS HE35,
		T.N.value('HE100[1]','DECIMAL(14,5)')					AS HE100,
		T.N.value('Comision[1]'	,'DECIMAL(14,5)')				AS Comision,
		T.N.value('Remuneracion[1]'	,'DECIMAL(14,5)')			AS Remuneracion,
		T.N.value('Mes[1]','INT')								AS Mes,
		T.N.value('ValorMes[1]'	,'DECIMAL(14,5)')				AS ValorMes,
		T.N.value('ImporteMes[1]','DECIMAL(14,5)')				AS ImporteMes,
		T.N.value('Dias[1]'	,'INT')								AS Dias,
	    T.N.value('ValorDia[1]'	,'DECIMAL(14,5)')				AS ValorDia,
		T.N.value('ImporteDia[1]'	,'DECIMAL(14,5)')			AS ImporteDia,
		T.N.value('TotalCTS[1]','DECIMAL(14,5)')		AS TotalCTS
		FROM @XMLCTS.nodes('/ListaArchivoPlanoCTSDetalle/ArchivoPlanoCTSDetalle') AS T(N)	

		SET NOCOUNT OFF;
END
