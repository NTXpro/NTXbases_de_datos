CREATE PROC [ERP].[Usp_Ins_AsientoContable_CuentaPagar_Reprocesar]
@IdAsiento INT,
@IdComprobante INT,
@IdOrigen	INT,
@IdSistema INT
AS
BEGIN

SET QUERY_GOVERNOR_COST_LIMIT 16000
SET NOCOUNT ON;

------================ OBTENER DATOS PROVEEDOR ================------

DECLARE @TablaCliente TABLE(ID INT , IdEntidad INT , Nombre VARCHAR(250) ,IdTipoRelacion INT)
INSERT INTO  @TablaCliente SELECT PRO.ID,ENT.ID,ENT.Nombre,PRO.IdTipoRelacion 
							FROM ERP.AplicacionAnticipoPagar AAP
							INNER JOIN ERP.Proveedor PRO
							ON PRO.ID = AAP.IdProveedor
							INNER JOIN ERP.Entidad ENT
							ON ENT.ID = PRO.IdEntidad
							WHERE AAP.ID = @IdComprobante
------========================================------

------================ OBTENER PERIODO ================------
DECLARE @Fecha DATETIME = (SELECT FechaAplicacion FROM ERP.AplicacionAnticipoPagar WHERE ID = @IdComprobante);
DECLARE @IdEmpresa INT =(SELECT IdEmpresa FROM ERP.AplicacionAnticipoPagar WHERE ID = @IdComprobante);
DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio A WHERE A.Nombre = YEAR(@Fecha));
DECLARE @IdMes INT= (SELECT CAST(MONTH(@Fecha) AS INT)) --EL ID DEL MES ES IGUAL AL NUMERO DEL MES
DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes) 

------====================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO ================------
DECLARE @OrdenAsiento INT = (SELECT [ERP].[GenerarOrdenAsiento](@IdPeriodo, @IdEmpresa, @IdOrigen))
DECLARE @AbreviaturaOrigen CHAR(2) = (SELECT Abreviatura FROM [Maestro].[Origen] WHERE ID = @IdOrigen)
DECLARE @NombreAsiento VARCHAR(255) = @AbreviaturaOrigen + RIGHT('000000' + CAST(@OrdenAsiento AS VARCHAR(8)), 7)

------========================================================------

------================ ELIMINAMOS EL DETALLE ================------

DELETE FROM ERP.AsientoDetalle WHERE IdAsiento = @IdAsiento

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
										(SELECT ERP.ObtenerPlanCuentaByTipoComprobantePlanCuenta(AAP.IdEmpresa,AAP.IdTipoComprobante,@IdTipoRelacionCliente,AAP.IdMoneda,@IdSistema,@IdAnio)),
										(SELECT ERP.GenerarNombreAsientoDetalleCuentaPagar((SELECT IdCuentaPagar FROM ERP.AplicacionAnticipoPagar WHERE ID = @IdComprobante ))) Nombre,
										CAST(2 AS INT), --HABER 
										CASE WHEN AAP.IdMoneda = 1 THEN
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacion(@IdComprobante)) AS DECIMAL(14,2))
										ELSE
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacion(@IdComprobante))*TipoCambio AS DECIMAL(14,2))
										END,
										CASE WHEN AAP.IdMoneda = 2 THEN
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacion(@IdComprobante)) AS DECIMAL(14,2))
										ELSE
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleCabeceraAplicacion(@IdComprobante)) / TipoCambio AS DECIMAL(14,2))
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Documento,
										DATEADD(HOUR, 3, GETDATE())	,
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										@Fecha
										FROM ERP.AplicacionAnticipoPagar AAP
										WHERE AAP.ID = @IdComprobante
------=======================================================================------
------================ REGISTRAR ASIENTO DETALLE 42 (DETALLE ANTICIPO) ================------


DECLARE @OrdenAsiento42Detalle INT =2;
DECLARE @TablaPanCuenta42DetalleAplicacion TABLE(Indice INT, ID INT, IdPlanCuenta INT, IdCuentaPagar INT, IdTipoComprobante INT )

INSERT INTO @TablaPanCuenta42DetalleAplicacion
SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY IdPlanCuenta ASC), ID , IdPlanCuenta, IdCuentaPagar, IdTipoComprobante
FROM (SELECT AAPD.ID ID,
			(SELECT [ERP].[ObtenerPlanCuentaByTipoComprobantePlanCuenta](CP.IdEmpresa, CP.IdTipoComprobante, @IdTipoRelacionCliente, CP.IdMoneda, @IdSistema,@IdAnio)) IdPlanCuenta,
			AAPD.IdCuentaPagar	IdCuentaPagar , AAPD.IdTipoComprobante IdTipoComprobante
			FROM ERP.AplicacionAnticipoPagarDetalle AAPD 
			INNER JOIN ERP.CuentaPagar CP
			ON AAPD.IdCuentaPagar = CP.ID
			WHERE AAPD.IdAplicacionAnticipo = @IdComprobante)PlanCuenta

DECLARE @CountPlanCuenta INT = (SELECT COUNT(IdPlanCuenta)FROM @TablaPanCuenta42DetalleAplicacion)


DECLARE @Contador INT = 1;

WHILE @Contador <= @CountPlanCuenta
BEGIN

DECLARE @IdPlanCuenta INT = (SELECT IdPlanCuenta FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)
DECLARE @IdDetalle INT = (SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)
DECLARE @NombreAsientoDetalle VARCHAR(255) = (SELECT ERP.GenerarNombreAsientoDetalleCuentaPagar((SELECT IdCuentaPagar FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador)))
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
										CAST(1 AS INT), --DEBE
										CASE WHEN AAP.IdMoneda = 1 THEN
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacion((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador ))) AS DECIMAL(14,2))
										ELSE
											 CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacion((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))*TipoCambio AS DECIMAL(14,2))
										END,
										CASE WHEN AAP.IdMoneda = 2 THEN
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacion((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador ))) AS DECIMAL(14,2))
										ELSE
											CAST((SELECT ERP.ObtenerImporteAsientoDetalleAplicacion((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador ))) / TipoCambio AS DECIMAL(14,2))
										END,
										@IdEntidadCliente,
										@IdTipoComprobante,
										(SELECT ERP.ObtenerSerieAsientoDetalleAplicacion ((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))	Serie,
										(SELECT ERP.ObtenerDocumentoAsientoDetalleAplicacion ((SELECT ID FROM @TablaPanCuenta42DetalleAplicacion WHERE Indice =@Contador )))	Documento,
										DATEADD(HOUR, 3, GETDATE())	,
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										@Fecha
										FROM ERP.AplicacionAnticipoPagar AAP
										WHERE AAP.ID = @IdComprobante
	SET @Contador  = @Contador +1 ;
	END
------=======================================================================------


SET NOCOUNT OFF;
END
