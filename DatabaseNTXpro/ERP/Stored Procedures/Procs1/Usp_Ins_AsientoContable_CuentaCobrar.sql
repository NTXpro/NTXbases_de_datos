CREATE PROC [ERP].[Usp_Ins_AsientoContable_CuentaCobrar]
@IdAsiento	INT OUT,
@IdComprobante INT,
@IdOrigen	INT,
@IdSistema INT
AS
BEGIN

SET QUERY_GOVERNOR_COST_LIMIT 16000
SET NOCOUNT ON;

------================ OBTENER DATOS CLIENTE ================------
DECLARE @TablaCliente TABLE(ID INT , IdEntidad INT , Nombre VARCHAR(250) ,IdTipoRelacion INT)
INSERT INTO  @TablaCliente SELECT CLI.ID,ENT.ID,ENT.Nombre,CLI.IdTipoRelacion 
							FROM ERP.AplicacionAnticipoCobrar AAC
							INNER JOIN ERP.Cliente CLI
							ON CLI.ID = AAC.IdCliente
							INNER JOIN ERP.Entidad ENT
							ON ENT.ID = CLI.IdEntidad
							WHERE AAC.ID = @IdComprobante
------========================================------

------================ OBTENER PERIODO ================------
DECLARE @Fecha DATETIME = (SELECT FechaAplicacion FROM ERP.AplicacionAnticipoCobrar WHERE ID = @IdComprobante);
DECLARE @IdEmpresa INT =(SELECT IdEmpresa FROM ERP.AplicacionAnticipoCobrar WHERE ID = @IdComprobante);
DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio A WHERE A.Nombre = YEAR(@Fecha));
DECLARE @IdMes INT= (SELECT CAST(MONTH(@Fecha) AS INT)) --EL ID DEL MES ES IGUAL AL NUMERO DEL MES
DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes) 


------====================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO ================------
DECLARE @OrdenAsiento INT = (SELECT ERP.GenerarOrdenAsiento(@IdPeriodo, @IdEmpresa, @IdOrigen))
DECLARE @AbreviaturaOrigen CHAR(2) = (SELECT Abreviatura FROM Maestro.Origen WHERE ID = @IdOrigen)
DECLARE @NombreAsiento VARCHAR(255) = @AbreviaturaOrigen + RIGHT('000000' + CAST(@OrdenAsiento AS VARCHAR(8)), 7)
DECLARE @IdCuentaCobrar INT = (SELECT IdCuentaCobrar FROM ERP.AplicacionAnticipoCobrar WHERE ID = @IdComprobante)

------========================================================------


------================ REGISTRAR ASIENTO ================------

INSERT INTO ERP.Asiento(
IdEmpresa,
IdPeriodo,
Nombre,
IdOrigen,
Orden,
Fecha,
IdMoneda,
TipoCambio,
FlagEditar,
FechaRegistro,
FlagBorrador,
Flag
)
SELECT IdEmpresa,
@IdPeriodo,
@NombreAsiento,
@IdOrigen,
@OrdenAsiento,
FechaAplicacion,
IdMoneda,
TipoCambio,
CAST(0 AS BIT),
GETDATE(),
CAST(0 AS BIT), 
CAST(1 AS BIT)
FROM ERP.AplicacionAnticipoCobrar
WHERE ID = @IdComprobante

SET @IdAsiento = (SELECT CAST(SCOPE_IDENTITY() AS INT))

------========================================================------


------================ OBTENER ORDEN Y NOMBRE ASIENTO DETALLE ================------

DECLARE @IdTipoRelacionCliente INT = (SELECT TOP 1 IdTipoRelacion FROM @TablaCliente)
DECLARE @IdEntidadCliente INT = (SELECT TOP 1 IdEntidad FROM @TablaCliente)

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE 42 (CABECERA ANTICIPO) ================------

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
								 FechaRegistro,
								 FlagBorrador,
								 Flag,
								 Fecha)
								 SELECT @IdAsiento,
										CAST(1 AS BIT) Orden,
										(SELECT ERP.ObtenerPlanCuentaByTipoComprobantePlanCuenta(AAC.IdEmpresa,AAC.IdTipoComprobante,@IdTipoRelacionCliente,AAC.IdMoneda,@IdSistema,@IdAnio)),
										(SELECT ERP.GenerarNombreAsientoDetalleCuentaCobrar((SELECT IdCuentaCobrar FROM ERP.AplicacionAnticipoCobrar WHERE ID = @IdComprobante ))) Nombre,
										CAST(1 AS INT), --DEBE
										CASE WHEN AAC.IdMoneda = 1 THEN
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacionCobrar(@IdComprobante))	 AS DECIMAL(14,2))
										ELSE
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacionCobrar(@IdComprobante)) AS DECIMAL(14,2))	*TipoCambio
										END,
										CASE WHEN AAC.IdMoneda = 2 THEN
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacionCobrar(@IdComprobante))	 AS DECIMAL(14,2))
										ELSE
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacionCobrar(@IdComprobante))	 / TipoCambio AS DECIMAL(14,2))
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Documento,
										DATEADD(HOUR, 3, GETDATE())	,
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaRegistro
										FROM ERP.AplicacionAnticipoCobrar AAC
										WHERE AAC.ID = @IdComprobante
------=======================================================================------


------================ REGISTRAR ASIENTO DETALLE 42 (DETALLE ANTICIPO) ================------

DECLARE @OrdenAsiento42Detalle INT =2;
DECLARE @TablaPanCuenta42DetalleAplicacion TABLE(Indice INT, ID INT, IdPlanCuenta INT, IdCuentaCobrar INT, IdTipoComprobante INT)

INSERT INTO @TablaPanCuenta42DetalleAplicacion
SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY IdPlanCuenta ASC), ID , IdPlanCuenta, IdCuentaCobrar, IdTipoComprobante
FROM (SELECT AACD.ID ID,
			(SELECT ERP.ObtenerPlanCuentaByTipoComprobantePlanCuenta(CC.IdEmpresa, CC.IdTipoComprobante, @IdTipoRelacionCliente, CC.IdMoneda, @IdSistema,@IdAnio)) IdPlanCuenta,
			AACD.IdCuentaCobrar	IdCuentaCobrar, AACD.IdTipoComprobante IdTipoComprobante
			FROM ERP.AplicacionAnticipoCobrarDetalle AACD 
			INNER JOIN ERP.CuentaCobrar CC
			ON AACD.IdCuentaCobrar = CC.ID
			WHERE AACD.IdAplicacionAnticipoCobrar = @IdComprobante)PlanCuenta

DECLARE @CountPlanCuenta INT = (SELECT COUNT(IdPlanCuenta)FROM @TablaPanCuenta42DetalleAplicacion)

DECLARE @Contador INT = 1;

WHILE @Contador <= @CountPlanCuenta
BEGIN

		DECLARE @IdPlanCuenta INT = (SELECT IdPlanCuenta FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)
		DECLARE @IdDetalle INT = (SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)
		DECLARE @NombreAsientoDetalle VARCHAR(255) = (SELECT ERP.GenerarNombreAsientoDetalleCuentaCobrar((SELECT IdCuentaCobrar FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)))
		DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)
	
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
								 FechaRegistro,
								 FlagBorrador,
								 Flag,
								 Fecha)
								 SELECT @IdAsiento,
										CAST(@OrdenAsiento42Detalle AS INT) Orden,
										@IdPlanCuenta,
										@NombreAsientoDetalle  Nombre,
										CAST(2 AS INT), --HABER
										CASE WHEN AAC.IdMoneda = 1 THEN
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacionCobrar((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))  AS DECIMAL(14,2))
										ELSE
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacionCobrar((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador ))) AS DECIMAL(14,2)) 	*TipoCambio
										END,
										CASE WHEN AAC.IdMoneda = 2 THEN
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacionCobrar((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))  AS DECIMAL(14,2))
										ELSE
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacionCobrar((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador ))) 	 / TipoCambio AS DECIMAL(14,2))
										END,
										@IdEntidadCliente,
										@IdTipoComprobante,
										(SELECT ERP.ObtenerSerieAsientoDetalleAplicacionCobrar ((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))		Serie,
										(SELECT ERP.ObtenerDocumentoAsientoDetalleAplicacionCobrar ((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))	Documento,
										DATEADD(HOUR, 3, GETDATE())	,
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaRegistro
										FROM ERP.AplicacionAnticipoCobrar AAC
										WHERE AAC.ID = @IdComprobante
	SET @Contador  = @Contador +1 ;
	SET @OrdenAsiento42Detalle = @OrdenAsiento42Detalle + 1 ; 
	END
------=======================================================================------

SET NOCOUNT OFF;
END
