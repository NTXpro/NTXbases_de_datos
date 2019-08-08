
CREATE PROC [ERP].[Usp_Ins_AsientoContable_Venta_Reprocesar] 
@IdAsiento INT,
@IdComprobante INT,
@IdOrigen INT,
@IdSistema INT
AS
BEGIN

SET QUERY_GOVERNOR_COST_LIMIT 16000
SET NOCOUNT ON;
------================ OBTENER DATOS CLIENTE ================------

DECLARE @TablaCliente TABLE (ID INT,IdEntidad INT,Nombre VARCHAR(250),IdTipoRelacion INT)
INSERT INTO @TablaCliente (ID, IdEntidad, Nombre, IdTipoRelacion)
SELECT CLI.ID, E.ID, E.Nombre, CLI.IdTipoRelacion
FROM ERP.Comprobante C 
INNER JOIN ERP.Cliente CLI
ON CLI.ID = C.IdCliente AND CLI.FlagBorrador = 0
INNER JOIN ERP.Entidad E 
ON E.ID = CLI.IdEntidad
WHERE C.ID = @IdComprobante

------====================================================------

------================ OBTENER PERIODO ================------

DECLARE @FechaComprobante DATETIME = (SELECT Fecha FROM ERP.Comprobante WHERE ID = @IdComprobante)
DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Comprobante WHERE ID = @IdComprobante)
DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio A WHERE A.Nombre = YEAR(@FechaComprobante))
DECLARE @IdMes INT= (SELECT CAST(MONTH(@FechaComprobante) AS INT)) --EL ID DEL MES ES IGUAL AL NUMERO DEL MES
DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes) 

------====================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO ================------
DECLARE @OrdenAsiento INT = (SELECT Orden FROM ERP.Asiento WHERE ID  = @IdAsiento)
DECLARE @AbreviaturaOrigen CHAR(2) = (SELECT Abreviatura FROM [Maestro].[Origen] WHERE ID = @IdOrigen)
------========================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO DETALLE ================------

DECLARE @NombreAsiento VARCHAR(255) = (SELECT [ERP].[GenerarNombreAsientoVenta](@IdComprobante))
DECLARE @IdTipoRelacionCliente INT = (SELECT TOP 1 IdTipoRelacion FROM @TablaCliente)
DECLARE @IdEntidadCliente INT = (SELECT TOP 1 IdEntidad FROM @TablaCliente)
------=======================================================================------

DELETE FROM ERP.AsientoDetalle WHERE IdAsiento = @IdAsiento

------================ REGISTRAR ASIENTO DETALLE 12 ================------

INSERT INTO ERP.AsientoDetalle(
IdAsiento,
Orden,
IdPlanCuenta,
Nombre,
IdDebeHaber,
ImporteSoles,
ImporteDolares,
IdEntidad,
IdTipoComprobante,
Serie,
Documento,
Fecha,
FechaRegistro,
FlagBorrador,
Flag
)
SELECT @IdAsiento,
CAST(1 AS INT) Orden,
(SELECT [ERP].[ObtenerPlanCuentaByTipoComprobantePlanCuenta](C.IdEmpresa, C.IdTipoComprobante, @IdTipoRelacionCliente, C.IdMoneda, @IdSistema,(SELECT ID FROM Maestro.Anio WHERE Nombre =  YEAR(C.Fecha)))),
@NombreAsiento,
CASE WHEN C.IdTipoComprobante IN (8,183) THEN
	CAST(2 AS INT)
ELSE
	CAST(1 AS INT)
END
, --DEBE
CASE WHEN C.IdComprobanteEstado = 3 THEN
	CAST(0 AS DECIMAL(15,2))
WHEN C.IdMoneda = 1 THEN
	CAST(Total AS DECIMAL(14,2))
ELSE
	CAST(Total * TipoCambio AS DECIMAL(14,2))
END,
CASE WHEN C.IdComprobanteEstado = 3 THEN
	CAST(0 AS DECIMAL(15,2))
WHEN C.IdMoneda = 2 THEN
	CAST(Total AS DECIMAL(14,2))
ELSE
	CAST(Total / TipoCambio AS DECIMAL(14,2))
END,
@IdEntidadCliente,
IdTipoComprobante,
Serie,
Documento,
Fecha,
GETDATE(),
CAST(0 AS BIT),
CAST(1 AS BIT)
FROM ERP.Comprobante C
WHERE ID = @IdComprobante

------==============================================================------

------================ REGISTRAR ASIENTO DETALLE 40 ================------
DECLARE @OrdenAsiento70 INT = 2;
DECLARE @IGV DECIMAL(14,5) = (SELECT IGV FROM ERP.Comprobante WHERE ID = @IdComprobante) 

IF @IGV != 0
BEGIN
SET @OrdenAsiento70 = 3;
INSERT INTO ERP.AsientoDetalle(
IdAsiento,
Orden,
IdPlanCuenta,
Nombre,
IdDebeHaber,
ImporteSoles,
ImporteDolares,
IdEntidad,
IdTipoComprobante,
Serie,
Documento,
Fecha,
FechaRegistro,
FlagBorrador,
Flag
)
SELECT @IdAsiento,
CAST(2 AS INT) Orden,
(SELECT [ERP].[ObtenerPlanCuentaAsiento40](@IdEmpresa,C.Fecha)),
@NombreAsiento,
CASE WHEN C.IdTipoComprobante IN (8,183) THEN
	CAST(1 AS INT)
ELSE
	CAST(2 AS INT)
END, --HABER
CASE WHEN C.IdComprobanteEstado = 3 THEN
	CAST(0 AS DECIMAL(15,2))
WHEN C.IdMoneda = 1 THEN
	CAST(IGV AS DECIMAL(14,2))
ELSE
	CAST(IGV * TipoCambio AS DECIMAL(14,2))
END,
CASE WHEN C.IdComprobanteEstado = 3 THEN
	CAST(0 AS DECIMAL(15,2))
WHEN C.IdMoneda = 2 THEN
	CAST(IGV AS DECIMAL(14,2))
ELSE
	CAST(IGV / TipoCambio AS DECIMAL(14,2))
END,
@IdEntidadCliente,
IdTipoComprobante,
Serie,
Documento,
Fecha,
GETDATE(),
CAST(0 AS BIT),
CAST(1 AS BIT)
FROM ERP.Comprobante C
WHERE ID = @IdComprobante
END
------==============================================================------

------================ REGISTRAR ASIENTO DETALLE 70 ================------
DECLARE @TablaPlanCuenta70 TABLE (Indice INT,IdPlanCuenta INT)
INSERT INTO @TablaPlanCuenta70 
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY IdPlanCuenta ASC),* 
FROM (SELECT DISTINCT IdPlanCuenta FROM ERP.ComprobanteDetalle CD
INNER JOIN ERP.Producto P
ON P.ID = CD.IdProducto
WHERE IdComprobante = @IdComprobante) PlanCuenta

DECLARE @CountPlanCuenta INT = (SELECT COUNT(DISTINCT ISNULL(IdPlanCuenta,0)) FROM ERP.ComprobanteDetalle CD
INNER JOIN ERP.Producto P
ON P.ID = CD.IdProducto
WHERE IdComprobante = @IdComprobante)

DECLARE @Contador INT = 1;
WHILE @Contador <= @CountPlanCuenta
BEGIN
DECLARE @IdPlanCuenta INT = (SELECT IdPlanCuenta FROM @TablaPlanCuenta70 WHERE Indice = @Contador)
INSERT INTO ERP.AsientoDetalle(
IdAsiento,
Orden,
IdPlanCuenta,
Nombre,
IdDebeHaber,
ImporteSoles,
ImporteDolares,
IdEntidad,
IdTipoComprobante,
Serie,
Documento,
Fecha,
FechaRegistro,
FlagBorrador,
Flag
)
SELECT @IdAsiento,
CAST(@OrdenAsiento70 AS INT) Orden,
(SELECT [ERP].[ObtenerPlanCuentaAsientoByFecha] (@IdPlanCuenta,C.Fecha,@IdEmpresa)),
@NombreAsiento,
CASE WHEN C.IdTipoComprobante IN (8,183) THEN
	CAST(1 AS INT)
ELSE
	CAST(2 AS INT)
END, --HABER
CASE WHEN C.IdComprobanteEstado = 3 THEN
	CAST(CAST(0 AS DECIMAL(15,2)) AS DECIMAL(14,2))
WHEN @CountPlanCuenta = 1 AND C.IdMoneda = 1 THEN
	CAST(C.SubTotal AS DECIMAL(14,2))
WHEN @CountPlanCuenta = 1 AND C.IdMoneda = 2 THEN
	CAST(C.SubTotal * TipoCambio AS DECIMAL(14,2))
ELSE
	CAST((SELECT [ERP].[ObtenerImporteAsiento70_By_IdPlanCuenta](@IdComprobante,@IdPlanCuenta)) AS DECIMAL(14,2))
END,
------------------------------------
CASE WHEN C.IdComprobanteEstado = 3 THEN
	CAST(CAST(0 AS DECIMAL(15,2)) AS DECIMAL(14,2))
WHEN @CountPlanCuenta = 1 AND C.IdMoneda = 2 THEN
	CAST(C.SubTotal AS DECIMAL(14,2))
WHEN @CountPlanCuenta = 1 AND C.IdMoneda = 1 THEN
	CAST(C.SubTotal / TipoCambio AS DECIMAL(14,2))
ELSE
CAST(((SELECT [ERP].[ObtenerImporteAsiento70_By_IdPlanCuenta](@IdComprobante,@IdPlanCuenta)) / TipoCambio) AS DECIMAL(14,2))
END,
@IdEntidadCliente,
IdTipoComprobante,
Serie,
Documento,
Fecha,
GETDATE(),
CAST(0 AS BIT),
CAST(1 AS BIT)
FROM ERP.Comprobante C
WHERE ID = @IdComprobante

SET @Contador = @Contador + 1
SET @OrdenAsiento70 = @OrdenAsiento70 + 1;
END
------==============================================================------

------================ DISMINUIR PUNTO DECIMAL ================------
DECLARE @Total DECIMAL(14,2) = (SELECT CASE WHEN C.IdComprobanteEstado = 3 THEN
											CAST(0 AS DECIMAL(15,2))
										WHEN C.IdMoneda = 1 THEN
											CAST(Total AS DECIMAL(14,2))
										ELSE
											CAST(Total * TipoCambio AS DECIMAL(14,2))
										END 
										FROM ERP.Comprobante C
										WHERE ID = @IdComprobante)

DECLARE @TotalDebe DECIMAL(14,2) = (SELECT SUM(ImporteSoles) FROM ERP.AsientoDetalle WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 1);  
DECLARE @TotalHaber DECIMAL(14,2) = (SELECT SUM(ImporteSoles) FROM ERP.AsientoDetalle WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 2);  
DECLARE @TotalDiferencia DECIMAL(14,2) = 0;
DECLARE @IdAsientoDetalle INT = 0;

IF @TotalDebe != @Total
BEGIN
	SET @TotalDiferencia = @Total - @TotalDebe;
	SET @IdAsientoDetalle = (SELECT TOP 1 MAX(ID) FROM ERP.AsientoDetalle WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 1)
	UPDATE ERP.AsientoDetalle SET ImporteSoles = ImporteSoles + @TotalDiferencia WHERE ID = @IdAsientoDetalle;
END

IF @TotalHaber != @Total
BEGIN
	SET @TotalDiferencia = @Total - @TotalHaber;
	SET @IdAsientoDetalle = (SELECT TOP 1 MAX(ID) FROM ERP.AsientoDetalle WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 2)
	UPDATE ERP.AsientoDetalle SET ImporteSoles = ImporteSoles + @TotalDiferencia WHERE ID = @IdAsientoDetalle;
END
------==============================================================------
SET NOCOUNT OFF;
END
