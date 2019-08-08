
CREATE PROC [ERP].[Usp_Upd_Vacacion]
@ID INT,
@XMLVacacion	 XML
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

	UPDATE ERP.Vacacion SET
	IdPeriodo = T.N.value('IdPeriodo[1]',			'INT'),
	FechaInicio = T.N.value('FechaInicio[1]',			'DATETIME'),
	FechaFin = T.N.value('FechaFin[1]',			'DATETIME'),
	Corresponde = T.N.value('Corresponde[1]',			'VARCHAR(10)'),
	HNormal = 	 T.N.value('HNormal[1]',				'DECIMAL(14,5)'),
	SueldoMinimo = 	T.N.value('SueldoMinimo[1]',		'DECIMAL(14,5)'),
	PorcentajeAFamiliar= T.N.value('PorcentajeAFamiliar[1]',	'DECIMAL(14,5)'),
	AFamiliar = T.N.value('AFamiliar[1]',			'DECIMAL(14,5)'),
	HE25 = T.N.value('HE25[1]',				'DECIMAL(14,5)'),
	HE35 = T.N.value('HE35[1]',				'DECIMAL(14,5)'),
	HE100 = T.N.value('HE100[1]',				'DECIMAL(14,5)'),
	Bonificacion = T.N.value('Bonificacion[1]',		'DECIMAL(14,5)'),
	Comision = T.N.value('Comision[1]',			'DECIMAL(14,5)'),
	Promedio = T.N.value('Promedio[1]',			'DECIMAL(14,5)'),
	ValorDia = T.N.value('ValorDia[1]',			'DECIMAL(14,5)'),
	Dias = T.N.value('Dias[1]',				'DECIMAL(14,5)'),
	Total = T.N.value('Total[1]',				'DECIMAL(14,5)'),
	UsuarioModifico = T.N.value('UsuarioModifico[1]',		'VARCHAR(250)'),
	FechaModificado = @FechaActual
	FROM @XMLVacacion.nodes('/ArchivoPlanoVacacion')	AS T(N)
	WHERE ID = @ID
END
