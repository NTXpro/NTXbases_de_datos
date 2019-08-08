CREATE PROC ERP.Usp_Ins_Vacacion
@XMLVacacion	 XML
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
	INSERT INTO [ERP].[Vacacion] ( 
								   IdDatoLaboral
								  ,IdEmpresa
								  ,IdPeriodo
								  ,FechaInicio
								  ,FechaFin
								  ,Corresponde
								  ,HNormal
								  ,SueldoMinimo
								  ,PorcentajeAFamiliar
								  ,AFamiliar
								  ,HE25
								  ,HE35
								  ,HE100
								  ,Bonificacion
								  ,Comision
								  ,Promedio
								  ,ValorDia
								  ,Dias
								  ,Total
								  ,Flag
								  ,UsuarioRegistro
								  ,FechaRegistro)
  SELECT
			T.N.value('IdDatoLaboral[1]',		'INT')				AS IdDatoLaboral,
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			T.N.value('IdPeriodo[1]',			'INT')				AS IdPeriodo,
			T.N.value('FechaInicio[1]',			'DATETIME')			AS FechaInicio,
			T.N.value('FechaFin[1]',			'DATETIME')			AS FechaFin,
			T.N.value('Corresponde[1]',			'VARCHAR(10)')		AS Corresponde,
			T.N.value('HNormal[1]',				'DECIMAL(14,5)')	AS HNormal,
			T.N.value('SueldoMinimo[1]',		'DECIMAL(14,5)')	AS SueldoMinimo,
			T.N.value('PorcentajeAFamiliar[1]',	'DECIMAL(14,5)')	AS PorcentajeAFamiliar,
			T.N.value('AFamiliar[1]',			'DECIMAL(14,5)')	AS AFamiliar,
			T.N.value('HE25[1]',				'DECIMAL(14,5)')	AS HE25,
			T.N.value('HE35[1]',				'DECIMAL(14,5)')	AS HE35,
			T.N.value('HE100[1]',				'DECIMAL(14,5)')	AS HE100,
			T.N.value('Bonificacion[1]',		'DECIMAL(14,5)')	AS Bonificacion,
			T.N.value('Comision[1]',			'DECIMAL(14,5)')	AS Comision,
			T.N.value('Promedio[1]',			'DECIMAL(14,5)')	AS Promedio,
			T.N.value('ValorDia[1]',			'DECIMAL(14,5)')	AS ValorDia,
			T.N.value('Dias[1]',				'DECIMAL(14,5)')	AS Dias,
			T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Total,
			T.N.value('Flag[1]',				'BIT')				AS Flag,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			@FechaActual
		FROM @XMLVacacion.nodes('/ArchivoPlanoVacacion')	AS T(N)
		DECLARE @IdVacacion INT = SCOPE_IDENTITY() 
		SELECT @IdVacacion
END
