
CREATE PROC [ERP].[Usp_Ins_AsientoContable_Tesoreria] 
@IdAsiento INT OUT,
@IdMovimiento INT,
@IdOrigen INT,
@IdSistema INT
AS
BEGIN

SET QUERY_GOVERNOR_COST_LIMIT 16000
SET NOCOUNT ON;
------================ OBTENER DATOS CLIENTE ================------

DECLARE @TablaCliente TABLE (ID INT,IdEntidad INT,Nombre VARCHAR(250),IdTipoRelacion INT)
INSERT INTO @TablaCliente 
SELECT TOP 1 CASE WHEN M.IdTipoMovimiento = 1 THEN
			 CLI.ID
			ELSE 
			 P.ID
			END, 
			E.ID, 
			E.Nombre, 
			CASE WHEN M.IdTipoMovimiento = 1 THEN 
			 CLI.IdTipoRelacion
			ELSE
			P.ID
	   END
FROM ERP.MovimientoTesoreria M 
INNER JOIN ERP.Entidad E
ON E.ID = M.IdEntidad
LEFT JOIN ERP.Cliente CLI
ON CLI.IdEntidad = E.ID AND CLI.FlagBorrador = 0
LEFT JOIN ERP.Proveedor P
ON P.IdEntidad = E.ID AND P.FlagBorrador = 0
WHERE M.ID = @IdMovimiento

------====================================================------

------================ OBTENER PERIODO ================------

DECLARE @FechaMovimiento DATETIME = (SELECT Fecha FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimiento)
DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimiento)
DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio A WHERE A.Nombre = YEAR(@FechaMovimiento))
DECLARE @IdMes INT= (SELECT CAST(MONTH(@FechaMovimiento) AS INT)) --EL ID DEL MES ES IGUAL AL NUMERO DEL MES
DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes) 

------====================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO ================------
DECLARE @OrdenAsiento INT = (SELECT [ERP].[GenerarOrdenAsiento](@IdPeriodo, @IdEmpresa, @IdOrigen))
DECLARE @AbreviaturaOrigen CHAR(2) = (SELECT RIGHT('0' + CAST(IdTipoMovimiento AS CHAR(1)), 2) FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimiento)
DECLARE @NombreAsiento VARCHAR(255) = (SELECT UPPER(TC.Nombre + ' '+ C.Nombre+ ' ORDEN ' + CAST(MT.Orden AS VARCHAR(20)) + ' ' + TM.Nombre + ' '+ CTM.Nombre) 
										FROM ERP.MovimientoTesoreria MT
										LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
										LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = MT.IdTipoMovimiento
										INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
										INNER JOIN Maestro.TipoCuenta TC ON TC.ID = C.IdTipoCuenta
										WHERE MT.ID = @IdMovimiento)

------========================================================------

------================ REGISTRAR ASIENTO ================------

INSERT INTO ERP.Asiento(
IdEmpresa,
IdPeriodo,
Nombre,
Referencia,
IdOrigen,
Orden,
Fecha,
IdMoneda,
TipoCambio,
FlagEditar,
UsuarioRegistro,
FechaRegistro,
FlagBorrador,
Flag
)
SELECT MT.IdEmpresa,
@IdPeriodo,
@NombreAsiento,
C.Nombre + '-'+cast(MT.Orden as varchar(20)),
@IdOrigen,
@OrdenAsiento,
MT.Fecha,
C.IdMoneda,
MT.TipoCambio,
CAST(0 AS BIT),
MT.UsuarioRegistro,
GETDATE(),
CAST(0 AS BIT), 
CAST(1 AS BIT)
FROM ERP.MovimientoTesoreria MT
LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = MT.IdTipoMovimiento
INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
WHERE MT.ID = @IdMovimiento

SET @IdAsiento = (SELECT CAST(SCOPE_IDENTITY() AS INT))
------========================================================------

DECLARE @TableAsientoDetalle TABLE(
	Identificador INT IDENTITY,
	IdAsiento INT,
	Orden INT NULL,
	IdPlanCuenta INT NULL,
	Nombre VARCHAR(MAX) NULL,
	IdDebeHaber INT NULL,
	ImporteSoles DECIMAL(14,5) NULL,
	ImporteDolares DECIMAL(14,5) NULL,
	IdEntidad INT NULL,
	IdProyecto INT NULL,
	IdTipoComprobante INT NULL,
	Serie VARCHAR(50) NULL,
	Documento VARCHAR(MAX) NULL,
	Fecha DATETIME NULL,
	FechaRegistro DATETIME NULL,
	FlagBorrador BIT,
	Flag BIT,
	FlagAutomatico bit
);



------================ REGISTRAR ASIENTO DETALLE TOTAL ================------

INSERT INTO @TableAsientoDetalle
SELECT @IdAsiento,
CAST(1 AS INT) Orden,
(SELECT [ERP].[ObtenerPlanCuentaAsientoByFecha] (C.IdPlanCuenta,MT.Fecha,@IdEmpresa)),
CASE WHEN MT.FlagTransferencia = 1 THEN
	(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MT.IdCuenta))
ELSE
	MT.Nombre
END,
CASE WHEN MT.IdTipoMovimiento = 1 THEN
	CAST(1 AS INT) --DEBE
ELSE
	CAST(2 AS INT) --HABER
END,
CASE WHEN MT.Flag = 0 THEN
	CAST(0 AS DECIMAL(14,2))
WHEN C.IdMoneda = 1 THEN
	CAST(Total AS DECIMAL(14,2))
ELSE
	CAST(Total * TipoCambio AS DECIMAL(14,2))
END,
CASE WHEN MT.Flag = 0 THEN
	CAST(0 AS DECIMAL(14,2))
WHEN C.IdMoneda = 1 THEN
	CAST(Total / TipoCambio AS DECIMAL(14,2))
ELSE
	CAST(Total AS DECIMAL(14,2))
END,
C.IdEntidad,
NULL,
NULL,
NULL,
CASE WHEN MT.FlagTransferencia = 1 THEN
	(SELECT TOP 1 Documento FROM ERP.MovimientoTesoreriaDetalle WHERE IdMovimientoTesoreria = @IdMovimiento)
ELSE
	MT.Voucher
END,
MT.Fecha,
GETDATE(),
CAST(0 AS BIT),
CAST(1 AS BIT),
CAST(0 AS BIT)
FROM ERP.MovimientoTesoreria MT
INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
WHERE MT.ID = @IdMovimiento

------==============================================================------

------================ REGISTRAR ASIENTO DETALLE 70 ================------
DECLARE @OrdenAsientoDetalle INT = 2;
DECLARE @TablaMovimientoTesoreriaDetalle TABLE (Indice INT,IdMovimientoTesoreriaDetalle INT)
INSERT INTO @TablaMovimientoTesoreriaDetalle 
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY ID ASC),* 
FROM (SELECT DISTINCT MTD.ID FROM ERP.MovimientoTesoreriaDetalle MTD
WHERE IdMovimientoTesoreria = @IdMovimiento) MovimientoTesoreriaDetalle

DECLARE @CountMovimientoTesoreriaDetalle INT = (SELECT COUNT(Indice) FROM @TablaMovimientoTesoreriaDetalle)

DECLARE @Contador INT = 1;
WHILE @Contador <= @CountMovimientoTesoreriaDetalle
BEGIN
DECLARE @IdMovimientoDetalle INT = (SELECT IdMovimientoTesoreriaDetalle FROM @TablaMovimientoTesoreriaDetalle WHERE Indice = @Contador);

INSERT INTO @TableAsientoDetalle
SELECT @IdAsiento,
@OrdenAsientoDetalle Orden,
(SELECT [ERP].[ObtenerPlanCuentaAsientoByFecha] (MTD.IdPlanCuenta,MT.Fecha,@IdEmpresa)),
CASE WHEN MTD.PagarCobrar != 'T' AND MT.FlagTransferencia = 0 AND E.ID IS NOT NULL THEN
(SELECT [ERP].[GenerarNombreAsientoDetalleTesoreria](MTD.IdTipoComprobante, MTD.Serie, MTD.Documento, E.Nombre))
ELSE
	MTD.Nombre
END,
MTD.IdDebeHaber, --HABER
CASE WHEN MT.Flag = 0 THEN
	CAST(0 AS DECIMAL(14,2))
WHEN  C.IdMoneda = 1 THEN
	CAST(MTD.Total AS DECIMAL(14,2))
ELSE
	CAST(MTD.Total * MT.TipoCambio AS DECIMAL(14,2))
END,
------------------------------------
CASE WHEN MT.Flag = 0 THEN
	CAST(0 AS DECIMAL(14,2))
WHEN  C.IdMoneda = 1 THEN
	CAST(MTD.Total / MT.TipoCambio AS DECIMAL(14,2))
ELSE
	CAST(MTD.Total AS DECIMAL(14,2))
END,
MTD.IdEntidad,
MTD.IdProyecto,
IdTipoComprobante,
Serie,
Documento,
MT.Fecha,
GETDATE(),
CAST(0 AS BIT),
CAST(1 AS BIT),
CAST(0 AS BIT)
FROM ERP.MovimientoTesoreriaDetalle MTD
INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
LEFT JOIN ERP.Entidad E ON E.ID = MTD.IdEntidad
WHERE MTD.ID = @IdMovimientoDetalle
SET @Contador = @Contador + 1
SET @OrdenAsientoDetalle = @OrdenAsientoDetalle + 1;
END
------==============================================================------
------================ DISMINUIR PUNTO DECIMAL ================------
DECLARE @Total DECIMAL(14,2) = (SELECT ImporteSoles FROM @TableAsientoDetalle WHERE Orden = 1);
DECLARE @IdDebeHaberTotal INT = (SELECT IdDebeHaber FROM @TableAsientoDetalle WHERE Orden = 1);
DECLARE @TotalDetalle DECIMAL(14,2) = (SELECT SUM(CASE WHEN IdDebeHaber != @IdDebeHaberTotal THEN
													 ImporteSoles
												  ELSE 
													-ImporteSoles
												  END) FROM @TableAsientoDetalle WHERE IdAsiento = @IdAsiento AND Orden != 1);  
DECLARE @TotalDiferencia DECIMAL(14,2) = 0;
DECLARE @Orden INT = 0;

IF @TotalDetalle != @Total
BEGIN
	SET @TotalDiferencia = @Total - @TotalDetalle;
	SET @Orden = (SELECT TOP 1 MAX(Orden) FROM @TableAsientoDetalle WHERE IdAsiento = @IdAsiento AND IdDebeHaber != @IdDebeHaberTotal)
	UPDATE @TableAsientoDetalle SET ImporteSoles = ImporteSoles + @TotalDiferencia WHERE Orden = @Orden;
END
------==============================================================------
------=======================GENERAR DESTINO PLAN CUENTA===================------

INSERT INTO @TableAsientoDetalle
SELECT
	@IdAsiento,
	(SELECT COUNT(1) FROM @TableAsientoDetalle) + AD.Orden,
	PC.ID AS IdPlanCuenta,
	AD.Nombre,
	DH.ID AS IdDebeHaber,
	CAST((PCD.Porcentaje * AD.ImporteSoles) / 100 AS DECIMAL(14,2)) AS ImporteSoles,
	CAST((PCD.Porcentaje * AD.ImporteDolares) / 100  AS DECIMAL(14,2)) AS ImporteDolares,
	AD.IdEntidad,
	CASE P.EstadoProyecto WHEN 1 THEN AD.IdProyecto ELSE NULL END AS IdProyecto,
	AD.IdTipoComprobante,
	AD.Serie,
	AD.Documento,
	AD.Fecha,
	GETDATE(),
	CAST(0 AS BIT),
	CAST(1 AS BIT),
	CAST(1 AS BIT)
FROM ERP.PlanCuentaDestino PCD
INNER JOIN @TableAsientoDetalle AD ON PCD.IdPlanCuentaOrigen = AD.IdPlanCuenta
LEFT JOIN Maestro.DebeHaber DH ON DH.ID = 1 OR DH.ID = 2
LEFT JOIN ERP.PlanCuenta P ON P.ID = AD.IdPlanCuenta
INNER JOIN ERP.PlanCuenta PC ON CASE DH.ID WHEN 1 THEN PCD.IdPlanCuentaDestino1 ELSE PCD.IdPlanCuentaDestino2 END = PC.ID
SET NOCOUNT OFF;

------=======================INSERTAR ASIENTO DETALL===================------

INSERT INTO ERP.AsientoDetalle(
	IdAsiento,
	Orden,
	IdPlanCuenta,
	Nombre,
	IdDebeHaber,
	ImporteSoles,
	ImporteDolares,
	IdEntidad,
	IdProyecto,
	IdTipoComprobante,
	Serie,
	Documento,
	Fecha,
	FechaRegistro,
	FlagBorrador,
	Flag,
	FlagAutomatico
	)
	SELECT
		IdAsiento,
		Identificador,
		IdPlanCuenta,
		Nombre,
		IdDebeHaber,
		CAST(ImporteSoles AS DECIMAL(14,2)),
		CAST(ImporteDolares AS DECIMAL(14,2)),
		IdEntidad,
		IdProyecto,
		IdTipoComprobante,
		Serie,
		Documento,
		Fecha,
		FechaRegistro,
		FlagBorrador,
		Flag,
		FlagAutomatico
	FROM @TableAsientoDetalle
END