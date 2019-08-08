CREATE PROC [ERP].[Usp_Ins_Asiento]
@Nombre varchar(255),
@Orden int,
@Fecha datetime,
@IdEmpresa int,
@IdPeriodo int,
@IdOrigen int,
@IdMoneda int,
@TipoCambio decimal(14,5),
@UsuarioRegistro varchar(250),
@FechaRegistro datetime,
@FlagEditar bit,
@FlagBorrador bit,
@Flag bit,
@ListaAsientoDetalle XML,
@IdEntidad INT
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	--DECLARE @ORDEN_GENERADA INT = (SELECT MAX(ISNULL(Orden, 0)) + 1 FROM ERP.Asiento 
	--							  WHERE IdPeriodo = @IdPeriodo AND IdOrigen = @IdOrigen)

	DECLARE @ORDEN_GENERADA INT;
	DECLARE @ORDEN_EXISTENTE INT = (SELECT COUNT(1) FROM ERP.Asiento WHERE IdPeriodo = @IdPeriodo AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa)
	IF(@ORDEN_EXISTENTE > 0)
	BEGIN
		SET @ORDEN_GENERADA = (SELECT MAX(ISNULL(Orden, 0)) + 1 FROM ERP.Asiento WHERE IdPeriodo = @IdPeriodo AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa);
	END
	ELSE
	BEGIN
		SET @ORDEN_GENERADA = 1;
	END
	
	DECLARE @ID_ASIENTO INT;
	INSERT INTO [ERP].[Asiento]
           ([Nombre]
           ,[Orden]
           ,[Fecha]
           ,[IdEmpresa]
           ,[IdPeriodo]
           ,[IdOrigen]
           ,[IdMoneda]
           ,[TipoCambio]
           ,[UsuarioRegistro]
           ,[FechaRegistro]
		   ,UsuarioModifico
		   ,FechaModificado
           ,[FlagEditar]
           ,[FlagBorrador]
           ,[Flag])
     VALUES
           (@Nombre,
            (CASE @FlagBorrador WHEN 1 THEN NULL ELSE @ORDEN_GENERADA END),
            @Fecha,
			@IdEmpresa,
            (CASE @IdPeriodo WHEN 0 THEN NULL ELSE @IdPeriodo END),
            (CASE @IdOrigen WHEN 0 THEN NULL ELSE @IdOrigen END),
            (CASE @IdMoneda WHEN 0 THEN NULL ELSE @IdMoneda END),
            @TipoCambio,
            @UsuarioRegistro,
            @FechaRegistro,
			@UsuarioRegistro,
            @FechaRegistro,
            @FlagEditar,
            @FlagBorrador,
            @Flag)

	SET @ID_ASIENTO = CAST(SCOPE_IDENTITY() AS int)


	INSERT INTO [ERP].[AsientoDetalle]
           ([IdAsiento]
           ,[Orden]
           ,[IdPlanCuenta]
           ,[Nombre]
           ,[IdDebeHaber]
		   ,[IdProyecto]
		   ,[Fecha]
           ,[ImporteSoles]
           ,[ImporteDolares]
           ,[IdEntidad]
           ,[IdTipoComprobante]
           ,[Serie]
           ,[Documento]
           ,[UsuarioRegistro]
           ,[FechaRegistro]
           ,[FlagBorrador]
           ,[Flag])
	SELECT 
		@ID_ASIENTO,
		T.N.value('Orden[1]',	'INT') AS ORDEN,
		(CASE T.N.value('IdPlanCuenta[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdPlanCuenta[1]',	'INT') END) AS IDCUENTACONTABLE,
		T.N.value('Nombre[1]',	'VARCHAR(MAX)') AS NOMBRE,
		T.N.value('IdDebeHaber[1]',	'INT') AS IDDEBEHABER,
		(CASE T.N.value('IdProyecto[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdProyecto[1]',	'INT') END) AS IDPROYECTO,
		CONVERT(DATETIME, T.N.value('FechaStr[1]',	'VARCHAR(50)'), 103) AS FECHA,
		T.N.value('ImporteSoles[1]',	'DECIMAL(14,2)') AS IMPORTESOLES,
		T.N.value('ImporteDolares[1]',	'DECIMAL(14,2)') AS IMPORTEDOLARES,
		(CASE T.N.value('IdEntidad[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdEntidad[1]',	'INT') END) AS IDENTIDAD,
		(CASE T.N.value('IdTipoComprobante[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdTipoComprobante[1]',	'INT') END) AS IDTIPOCOMPROBANTE,	 
		--RIGHT('0000' + T.N.value('Serie[1]',	'INT'), 4) AS SERIE,
		T.N.value('Serie[1]',	'VARCHAR(50)') AS SERIE,
		T.N.value('Documento[1]', 'VARCHAR(MAX)') AS DOCUMENTO,
		@UsuarioRegistro,
		@FechaRegistro,
		@FlagBorrador,
        @Flag
	FROM 
	@ListaAsientoDetalle.nodes('/ListaAsientoDetalle/AsientoDetalle')	AS T(N)

	SELECT @ID_ASIENTO
END
