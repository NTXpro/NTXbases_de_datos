CREATE PROCEDURE [ERP].[Usp_Upd_Asiento]
@ID INT,
@Nombre varchar(255),
@Orden int,
@Fecha datetime,
@IdEmpresa int,
@IdPeriodo int,
@IdOrigen int,
@IdMoneda int,
@TipoCambio decimal(14,5),
@UsuarioModifico varchar(250),
@FechaModificado datetime,
@FlagEditar bit,
@FlagBorrador bit,
@Flag bit,
@ListaAsientoDetalle XML,
@IdEntidad INT
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
    DECLARE @ORDEN_GENERADA INT = (SELECT ISNULL(MAX(Orden), 0) + 1 FROM ERP.Asiento 
								   WHERE IdPeriodo = @IdPeriodo AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa)

	DECLARE @TableAsientoDetalle TABLE(
		Identificador INT IDENTITY,
		ID INT NULL,
		Orden INT NULL,
		IdPlanCuenta INT NULL,
		Nombre VARCHAR(MAX) NULL,
		IdDebeHaber INT NULL,
		IdProyecto INT NULL,
		Fecha DATETIME NULL,
		ImporteSoles DECIMAL(14,5) NULL,
		ImporteDolares DECIMAL(14,5) NULL,
		IdEntidad INT NULL,
		IdTipoComprobante INT NULL,
		Serie VARCHAR(50) NULL,
		Documento VARCHAR(MAX) NULL,
		FlagAutomatico bit
	);

	UPDATE [ERP].[Asiento] SET 
		[Nombre] = @Nombre,
		[Orden] = (CASE @FlagBorrador WHEN 1 THEN NULL ELSE 		
		(CASE WHEN [Orden] > 0 AND [Orden] IS NOT NULL THEN [Orden] ELSE @ORDEN_GENERADA END)	
		END),
		[Fecha] = @Fecha,
		[IdEmpresa] = @IdEmpresa,
		[IdPeriodo] = (CASE @IdPeriodo WHEN 0 THEN NULL ELSE @IdPeriodo END),
		[IdOrigen] = (CASE @IdOrigen WHEN 0 THEN NULL ELSE @IdOrigen END),
		[IdMoneda] = (CASE @IdMoneda WHEN 0 THEN NULL ELSE @IdMoneda END),
		[TipoCambio] = @TipoCambio,
		[UsuarioModifico] = @UsuarioModifico,
		[FechaModificado] = @FechaModificado,
		[FlagEditar] = @FlagEditar,
		[FlagBorrador] = @FlagBorrador,
		[Flag] = @Flag
	WHERE ID = @ID

	------------------- INSERTAR ASIENTOS DETALLE EN LA VARIABLE TIPO TABLA PARA TRABAJARLO -----------------
	INSERT INTO @TableAsientoDetalle
	SELECT
		T.N.value('ID[1]',	'BIGINT'),
		T.N.value('Orden[1]',	'INT'),
		(CASE T.N.value('IdPlanCuenta[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdPlanCuenta[1]',	'INT') END),
		T.N.value('Nombre[1]',	'VARCHAR(MAX)'),
		T.N.value('IdDebeHaber[1]',	'INT'),
		(CASE T.N.value('IdProyecto[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdProyecto[1]',	'INT') END),
		CONVERT(DATETIME, T.N.value('FechaStr[1]',	'VARCHAR(50)'), 103),
		T.N.value('ImporteSoles[1]',	'DECIMAL(14,2)'),
		T.N.value('ImporteDolares[1]',	'DECIMAL(14,2)'),
		(CASE T.N.value('IdEntidad[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdEntidad[1]',	'INT') END),
		(CASE T.N.value('IdTipoComprobante[1]',	'INT') WHEN 0 THEN NULL ELSE T.N.value('IdTipoComprobante[1]',	'INT') END),
		T.N.value('Serie[1]', 'VARCHAR(50)') AS SERIE,
		T.N.value('Documento[1]', 'VARCHAR(MAX)') AS DOCUMENTO,
		0
	FROM 
	@ListaAsientoDetalle.nodes('/ListaAsientoDetalle/AsientoDetalle')	AS T(N)
	------------------------------------------------------------------------------------------------------------

	IF(@FlagBorrador = 0)
	BEGIN

	---------- ELIMINAR ASIENTOS DETALLE GENERADOS AUTOMATICAMENTE -----------
	DELETE ADXML FROM @TableAsientoDetalle ADXML
	INNER JOIN ERP.AsientoDetalle AD ON ADXML.ID = AD.ID
	WHERE AD.FlagAutomatico = 1;
	---------------------------------------------------------------------------

	----------------- INSERTAR ASIENTO GENERADOS AUTOMATICAMENTE EN LA VARIABLE TIPO TABLA -----------------
	INSERT INTO @TableAsientoDetalle
	SELECT
		0,
		AD.Orden,		
		PCD.IdPlanCuentaDestino1 AS IdPlanCuenta,
		AD.Nombre,
		CASE 
			WHEN AD.IdDebeHaber = 1 THEN 2
			ELSE 1
		END AS IdDebeHaber,	
		CASE P.EstadoProyecto 
			WHEN 1 THEN AD.IdProyecto 
			ELSE NULL 
		END AS IdProyecto,
		AD.Fecha,
		CAST((PCD.Porcentaje * AD.ImporteSoles) / 100 AS DECIMAL(14,2)) AS ImporteSoles,
		CAST((PCD.Porcentaje * AD.ImporteDolares) / 100 AS DECIMAL(14,2)) AS ImporteDolares,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		1
	FROM ERP.PlanCuentaDestino PCD
	INNER JOIN @TableAsientoDetalle AD ON PCD.IdPlanCuentaOrigen = AD.IdPlanCuenta	
	INNER JOIN ERP.PlanCuenta P ON P.ID = PCD.IdPlanCuentaDestino1

	INSERT INTO @TableAsientoDetalle
	SELECT
		0,
		AD.Orden,
		PCD.IdPlanCuentaDestino2 AS IdPlanCuenta,
		AD.Nombre,
		AD.IdDebeHaber,
		CASE P.EstadoProyecto
			WHEN 1 THEN AD.IdProyecto 
			ELSE NULL 
		END AS IdProyecto,
		AD.Fecha,
		CAST((PCD.Porcentaje * AD.ImporteSoles) / 100 AS DECIMAL(14,2)) AS ImporteSoles,
		CAST((PCD.Porcentaje * AD.ImporteDolares) / 100 AS DECIMAL(14,2)) AS ImporteDolares,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		1
	FROM ERP.PlanCuentaDestino PCD
	INNER JOIN @TableAsientoDetalle AD ON PCD.IdPlanCuentaOrigen = AD.IdPlanCuenta	
	INNER JOIN ERP.PlanCuenta P ON P.ID = PCD.IdPlanCuentaDestino2
		
	-----------------------------------------------------------------------------------------------------------
	
	END

	DELETE FROM [ERP].[AsientoDetalle] WHERE IdAsiento = @ID

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
		,[FlagBorrador]
		,[Flag]
		,[FlagAutomatico])
	SELECT 
		@ID,
		ROW_NUMBER() OVER (ORDER BY AD.Identificador) AS RowNumber,
		AD.IdPlanCuenta,
		AD.Nombre,
		AD.IdDebeHaber,
		AD.IdProyecto,
		AD.Fecha,
		CAST(AD.ImporteSoles AS DECIMAL(14,2)),
		CAST(AD.ImporteDolares AS DECIMAL(14,2)),
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		@FlagBorrador,
        @Flag,
		AD.FlagAutomatico
	FROM 
	@TableAsientoDetalle AS AD

	SELECT @ID;
END