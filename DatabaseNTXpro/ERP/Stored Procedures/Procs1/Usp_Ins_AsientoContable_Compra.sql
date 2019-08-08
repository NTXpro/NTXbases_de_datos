CREATE PROC [ERP].[Usp_Ins_AsientoContable_Compra]
@IdAsiento INT OUT,
@IdComprobante INT,
@IdOrigen	INT,
@IdSistema INT
AS 
BEGIN

SET QUERY_GOVERNOR_COST_LIMIT 16000
SET NOCOUNT ON;
------================ OBTENER DATOS PROVEEDOR ================------

DECLARE @TablaCliente TABLE (ID INT,IdEntidad INT,Nombre VARCHAR(250),IdTipoRelacion INT)
INSERT INTO @TablaCliente SELECT PRO.ID,E.ID,E.Nombre,PRO.IdTipoRelacion 
						  FROM ERP.Compra C
						  INNER JOIN ERP.Proveedor PRO
						  ON PRO.ID = C.IdProveedor
						  INNER JOIN ERP.Entidad E
						  ON E.ID = PRO.IdEntidad
						  WHERE C.ID = @IdComprobante

------========================================------

------================ OBTENER PERIODO ================------

DECLARE @IdPeriodo INT = (SELECT IdPeriodo FROM ERP.Compra WHERE ID =  @IdComprobante)
DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Compra WHERE ID = @IdComprobante)
DECLARE @IdAnio INT = (SELECT AN.ID FROM ERP.Periodo PE INNER JOIN Maestro.Anio AN ON PE.IdAnio = AN.ID WHERE PE.ID = @IdPeriodo)

------====================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO ================------

DECLARE @OrdenAsiento INT = (SELECT [ERP].[GenerarOrdenAsiento](@IdPeriodo, @IdEmpresa, @IdOrigen))
DECLARE @AbreviaturaOrigen CHAR(2)= (SELECT Abreviatura FROM [Maestro].[Origen] WHERE ID=@IdOrigen)
DECLARE @NombreAsiento VARCHAR(255) = @AbreviaturaOrigen + RIGHT('000000' + CAST(@OrdenAsiento AS VARCHAR(8)), 7)
DECLARE @NombreAsientoDetalle VARCHAR(1000) = (SELECT ERP.GenerarNombreAsientoDetalleCompra(@IdComprobante))

DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.Compra WHERE ID = @IdComprobante)

DECLARE @Debe INT = 1;
DECLARE @Haber INT = 2;

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
									   @NombreAsientoDetalle,
									   @IdOrigen,
									   @OrdenAsiento,
									   FechaEmision,
									   IdMoneda,
									   TipoCambio,
									   CAST(0 AS BIT),
									   GETDATE(),
									   CAST(0 AS BIT), 
									   CAST(1 AS BIT)
									   FROM ERP.Compra
									   WHERE ID = @IdComprobante
					
					SET @IdAsiento = (SELECT CAST(SCOPE_IDENTITY() AS INT))
------========================================================------

------================ OBTENER ORDEN Y NOMBRE ASIENTO DETALLE ================------

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
	IdTipoComprobante INT NULL,
	Serie VARCHAR(50) NULL,
	Documento VARCHAR(MAX) NULL,
	FechaRegistro DATETIME NULL,
	FlagBorrador BIT,
	Flag BIT,
	Fecha DATETIME NULL,
	FlagAutomatico BIT,
	IdProyecto INT
);

DECLARE @IdTipoRelacionCliente INT = (SELECT TOP 1 IdTipoRelacion FROM @TablaCliente)
DECLARE @IdEntidadCliente INT = (SELECT TOP 1 IdEntidad FROM @TablaCliente)

DECLARE @IdPlanCuentaOrigen INT;
DECLARE @IdAsientoDetalle INT ;

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE 40 (CABECERA COMPRA) ================------

DECLARE @OrdenAsiento40 INT = 1;

		INSERT INTO @TableAsientoDetalle
								 SELECT @IdAsiento,
										@OrdenAsiento40 Orden,
										(SELECT [ERP].[ObtenerPlanCuentaByTipoComprobantePlanCuenta](C.IdEmpresa, C.IdTipoComprobante, @IdTipoRelacionCliente, C.IdMoneda, @IdSistema,@IdAnio)),
										@NombreAsientoDetalle,
										CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
												CAST(2 AS INT) --HABER
										ELSE
												CAST(1 AS INT) --DEBE
										END,
										CASE WHEN C.IdMoneda = 1 THEN Total ELSE CAST(Total * TipoCambio AS DECIMAL(14,2)) END,
										CASE WHEN C.IdMoneda = 2 THEN Total ELSE CAST(Total / TipoCambio AS DECIMAL(14,2)) END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Numero,
										DATEADD(HOUR, 3, GETDATE()),
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaEmision,
										CAST(0 AS BIT),
										NULL
										FROM ERP.Compra C
										WHERE ID = @IdComprobante
------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE 90 (DETALLE COMPRA) ================------

DECLARE @OrdenAsiento90 INT = @OrdenAsiento40;
DECLARE @TablaPlanCuenta90DetalleCompra TABLE(Indice INT,ID INT ,IdPlanCuenta INT, IdProyecto INT)

INSERT INTO @TablaPlanCuenta90DetalleCompra
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY IdPlanCuenta DESC),ID,IdPlanCuenta,IdProyecto
FROM (SELECT ID,IdPlanCuenta,IdProyecto FROM ERP.CompraDetalle CD WHERE IdCompra = @IdComprobante) PlanCuenta

DECLARE @CountPlanCuenta INT = (SELECT COUNT(IdPlanCuenta) FROM ERP.CompraDetalle WHERE IdCompra = @IdComprobante)

DECLARE @Contador INT = 1;

WHILE @Contador <= @CountPlanCuenta
BEGIN 

DECLARE @IdPlanCuenta INT = (SELECT IdPlanCuenta FROM @TablaPlanCuenta90DetalleCompra WHERE Indice = @Contador)
DECLARE @IdProyecto INT = (SELECT IdProyecto FROM @TablaPlanCuenta90DetalleCompra WHERE Indice = @Contador)
DECLARE @IdDetalleCompra INT = (SELECT ID FROM @TablaPlanCuenta90DetalleCompra WHERE Indice = @Contador)

					INSERT INTO @TableAsientoDetalle
													SELECT @IdAsiento,
														   CAST(@OrdenAsiento90 AS INT) Orden,
														   @IdPlanCuenta,
														   @NombreAsientoDetalle,
														   CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
																	CAST(1 AS INT) --DEBE
															ELSE
																	CAST(2 AS INT) --HABER
															END,
														   CASE WHEN C.IdMoneda = 1 THEN
																CAST((SELECT [ERP].[ObtenerImporteAsiento90_By_IdCompra](@IdDetalleCompra))  AS DECIMAL(14,2))
															ELSE
																CAST((SELECT [ERP].[ObtenerImporteAsiento90_By_IdCompra](@IdDetalleCompra)) * TipoCambio AS DECIMAL(14,2))
															END,
															CASE WHEN C.IdMoneda = 2 THEN
																CAST((SELECT [ERP].[ObtenerImporteAsiento90_By_IdCompra](@IdDetalleCompra)) AS DECIMAL(14,2))
															ELSE
																CAST((SELECT [ERP].[ObtenerImporteAsiento90_By_IdCompra](@IdDetalleCompra)) / TipoCambio AS DECIMAL(14,2))
															END,
														   @IdEntidadCliente,
														   IdTipoComprobante,
														   Serie,
														   Numero,
														   DATEADD(HOUR, 3, GETDATE()),	
														   CAST(0 AS BIT),
														   CAST(1 AS BIT),
														   FechaEmision,
														   CAST(0 AS BIT),
														   @IdProyecto
														   FROM ERP.Compra C
														   WHERE ID = @IdComprobante
					SET @Contador = @Contador + 1
					SET @OrdenAsiento90 = @OrdenAsiento90 + 1;

END

------==============================================================------

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE IGV 40 (CABECERA COMPRA) ================------

DECLARE @OrdenAsiento40IGV INT = @OrdenAsiento90 ;
DECLARE @IGV DECIMAL(14,5) = (SELECT IGV FROM ERP.Compra WHERE ID = @IdComprobante)

IF @IGV !=0
BEGIN

					INSERT INTO @TableAsientoDetalle
													SELECT @IdAsiento,
														   CAST(@OrdenAsiento40IGV AS INT) Orden,
														   (SELECT [ERP].[ObtenerPlanCuentaIGV_Compra](@IdEmpresa,@IdPeriodo)),
														   @NombreAsientoDetalle,
														   CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
																	CAST(1 AS INT) --DEBE
															ELSE
																	CAST(2 AS INT) --HABER
															END,
														   CASE WHEN C.IdMoneda = 1 THEN
																IGV
															ELSE
																IGV * TipoCambio
															END,
														   CASE WHEN C.IdMoneda = 2 THEN
																IGV
															ELSE
																IGV / TipoCambio
															END,
														   @IdEntidadCliente,
														   IdTipoComprobante,
														   Serie,
														   Numero,
														   DATEADD(HOUR, 3, GETDATE()),
														   CAST(0 AS BIT),
														   CAST(1 AS BIT),
														   FechaEmision,
														    CAST(0 AS BIT),
															NULL
														   FROM ERP.Compra C
														   WHERE ID = @IdComprobante
							SET @OrdenAsiento40IGV = @OrdenAsiento40IGV + 1;
END

------=======================================================================------
------================ REGISTRAR ASIENTO DETALLE IMPUESTOS A LA RENTA 42 (CABECERA COMPRA) ================------
DECLARE @OrdenAsiento42 INT = @OrdenAsiento40IGV ;

DECLARE @IR DECIMAL(14,5) = (SELECT ImpuestoRenta FROM ERP.Compra WHERE ID = @IdComprobante)


IF @IR !=0
BEGIN
	INSERT INTO @TableAsientoDetalle
													SELECT @IdAsiento,
														   CAST(@OrdenAsiento40IGV AS INT) Orden,
														   (SELECT [ERP].[ObtenerPlanCuentaIR_Compra](@IdEmpresa,@IdPeriodo)),
														   @NombreAsientoDetalle,
														   CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
																	CAST(2 AS INT)--- HABER
															ELSE
																	CAST(1 AS INT) --DEBE
															END,
														   CASE WHEN C.IdMoneda = 1 THEN
																@IR
															ELSE
																@IR * TipoCambio
															END,
														   CASE WHEN C.IdMoneda = 2 THEN
																@IR
															ELSE
																@IR / TipoCambio
															END,
														   @IdEntidadCliente,
														   IdTipoComprobante,
														   Serie,
														   Numero,
														   DATEADD(HOUR, 3, GETDATE()),
														   CAST(0 AS BIT),
														   CAST(1 AS BIT),
														   FechaEmision,
														   CAST(0 AS BIT),
														   NULL
														   FROM ERP.Compra C
														   WHERE ID = @IdComprobante
							SET @OrdenAsiento42 = @OrdenAsiento42 + 1;
					END

------=======================================================================------
------================ REGISTRAR ASIENTO DETALLE IMPUESTO SEGUNDA CATEGORIA 42 (CABECERA COMPRA) ================------
DECLARE @OrdenAsientoSegunda INT = @OrdenAsiento42 ;

DECLARE @RS DECIMAL(14,5) = (SELECT ImpuestoRentaSegundaCategoria FROM ERP.Compra WHERE ID = @IdComprobante)


IF @RS !=0
BEGIN
	INSERT INTO @TableAsientoDetalle
													SELECT @IdAsiento,
														   CAST(@OrdenAsiento40IGV AS INT) Orden,
														   (SELECT [ERP].[ObtenerPlanCuentaIMS_Compra](@IdEmpresa,@IdPeriodo)),
														   @NombreAsientoDetalle,
														   CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
																	CAST(2 AS INT)--- HABER
															ELSE
																	CAST(1 AS INT) --DEBE
															END,
														   CASE WHEN C.IdMoneda = 1 THEN
																@RS
															ELSE
																@RS * TipoCambio
															END,
														   CASE WHEN C.IdMoneda = 2 THEN
																@RS
															ELSE
																@RS / TipoCambio
															END,
														   @IdEntidadCliente,
														   IdTipoComprobante,
														   Serie,
														   Numero,
														   DATEADD(HOUR, 3, GETDATE()),
														   CAST(0 AS BIT),
														   CAST(1 AS BIT),
														   FechaEmision,
														   CAST(0 AS BIT),
														   NULL
														   FROM ERP.Compra C
														   WHERE ID = @IdComprobante


							SET @OrdenAsientoSegunda = @OrdenAsientoSegunda + 1;
					END
------=======================================================================------
------================ REGISTRAR ASIENTO DETALLE ISC 40 (CABECERA COMPRA) ================------

DECLARE @OrdenAsiento40ISC INT = @OrdenAsientoSegunda;
DECLARE @ISC DECIMAL(14,5) = (SELECT ISC FROM ERP.Compra WHERE ID = @IdComprobante)

IF @ISC !=0
BEGIN

				INSERT INTO @TableAsientoDetalle
								 SELECT @IdAsiento,
										CAST(@OrdenAsiento40ISC AS INT) Orden,
										(SELECT [ERP].[ObtenerPlanCuentaISC_Compra](C.IdEmpresa,@IdPeriodo)),
										@NombreAsientoDetalle,
										CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
												CAST(1 AS INT) --DEBE
										ELSE
												CAST(2 AS INT)--- HABER
										END,
										CASE WHEN C.IdMoneda = 1 THEN
											ISC
										ELSE
											ISC * TipoCambio
										END,
										CASE WHEN C.IdMoneda = 2 THEN
											ISC
										ELSE
											ISC / TipoCambio
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Numero,
										DATEADD(HOUR, 3, GETDATE()),
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaEmision,
										CAST(0 AS BIT),
										NULL
										FROM ERP.Compra C
										WHERE ID = @IdComprobante

						SET @OrdenAsiento40ISC = @OrdenAsiento40ISC + 1 ;

END

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE OTROS IMPUESTOS 40 (CABECERA COMPRA) ================------


DECLARE @OrdenAsiento40OI INT = @OrdenAsiento40ISC;
DECLARE @OtrosImpuestos DECIMAL(14,5) = (SELECT OtroImpuesto FROM ERP.Compra WHERE ID = @IdComprobante)

IF @OtrosImpuestos !=0
BEGIN

				INSERT INTO @TableAsientoDetalle
								 SELECT @IdAsiento,
										CAST(@OrdenAsiento40OI AS INT) Orden,
										(SELECT [ERP].[ObtenerPlanCuentaOI_Compra](C.IdEmpresa,@IdPeriodo)),
										@NombreAsientoDetalle,
										CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
												CAST(1 AS INT) --DEBE
										ELSE
												CAST(2 AS INT)--- HABER
										END,
										CASE WHEN C.IdMoneda = 1 THEN
											OtroImpuesto
										ELSE
											OtroImpuesto * TipoCambio
										END,
										CASE WHEN C.IdMoneda = 2 THEN
											OtroImpuesto
										ELSE
											OtroImpuesto / TipoCambio
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Numero,
										DATEADD(HOUR, 3, GETDATE()),
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaEmision,
										CAST(0 AS BIT),
										NULL
										FROM ERP.Compra C
										WHERE ID = @IdComprobante

						SET @OrdenAsiento40OI = @OrdenAsiento40OI + 1 ;

END

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE DESCUENTO 90 (CABECERA COMPRA) ================------


DECLARE @OrdenAsiento90DES INT = @OrdenAsiento40OI;
DECLARE @Descuento DECIMAL(14,5) = (SELECT Descuento FROM ERP.Compra WHERE ID = @IdComprobante)

IF @Descuento !=0
BEGIN

				INSERT INTO @TableAsientoDetalle
								 SELECT @IdAsiento,
										CAST(@OrdenAsiento90DES AS INT) Orden,
										(SELECT [ERP].[ObtenerPlanCuentaDES_Compra](C.IdEmpresa,@IdPeriodo)),
										@NombreAsientoDetalle,
										CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
												CAST(2 AS INT)--- HABER
										ELSE
												CAST(1 AS INT) --DEBE
										END,
										CASE WHEN C.IdMoneda = 1 THEN
											Descuento
										ELSE
											Descuento * TipoCambio
										END,
										CASE WHEN C.IdMoneda = 2 THEN
											Descuento
										ELSE
											Descuento / TipoCambio
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Numero,
										DATEADD(HOUR, 3, GETDATE()),
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaEmision,
										CAST(0 AS BIT),
										NULL
										FROM ERP.Compra C
										WHERE ID = @IdComprobante

						SET @OrdenAsiento90DES = @OrdenAsiento90DES + 1 ;

END

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE REDONDEO SUMA 90 (CABECERA COMPRA) ================------


DECLARE @OrdenAsiento90RS INT = @OrdenAsiento90DES;
DECLARE @RedondeoSuma DECIMAL(14,5) = (SELECT RedondeoSuma FROM ERP.Compra WHERE ID = @IdComprobante)

IF @RedondeoSuma !=0
BEGIN

				INSERT INTO @TableAsientoDetalle
								 SELECT @IdAsiento,
										CAST(@OrdenAsiento90RS AS INT) Orden,
										(SELECT [ERP].[ObtenerPlanCuentaRS_Compra](C.IdEmpresa,@IdPeriodo)),
										@NombreAsientoDetalle,
										CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
												CAST(1 AS INT) --DEBE
										ELSE
												CAST(2 AS INT)--- HABER
										END,
										CASE WHEN C.IdMoneda = 1 THEN
											RedondeoSuma
										ELSE
											RedondeoSuma * TipoCambio
										END,
										CASE WHEN C.IdMoneda = 2 THEN
											RedondeoSuma
										ELSE
											RedondeoSuma / TipoCambio
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Numero,
										DATEADD(HOUR, 3, GETDATE()),
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaEmision,
										CAST(0 AS BIT),
										NULL
										FROM ERP.Compra C
										WHERE ID = @IdComprobante

						SET @OrdenAsiento90RS = @OrdenAsiento90RS + 1 ;

END

------=======================================================================------

------================ REGISTRAR ASIENTO DETALLE REDONDEO RESTA 90 (CABECERA COMPRA) ================------


DECLARE @OrdenAsiento90Rr INT = @OrdenAsiento90RS;
DECLARE @RedondeoResto DECIMAL(14,5) = (SELECT RedondeoResta FROM ERP.Compra WHERE ID = @IdComprobante)

IF @RedondeoResto !=0
BEGIN

				INSERT INTO @TableAsientoDetalle
								 SELECT @IdAsiento,
										CAST(@OrdenAsiento90Rr AS INT) Orden,
										(SELECT [ERP].[ObtenerPlanCuentaRR_Compra](C.IdEmpresa,@IdPeriodo)),
										@NombreAsientoDetalle,
										CASE WHEN C.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE '%CR%' AND ID != 59) THEN
												CAST(2 AS INT) --HABER
										ELSE
												CAST(1 AS INT)--- DEBE
										END,
										CASE WHEN C.IdMoneda = 1 THEN
											RedondeoResta
										ELSE
											RedondeoResta * TipoCambio
										END,
										CASE WHEN C.IdMoneda = 2 THEN
											RedondeoResta
										ELSE
											RedondeoResta / TipoCambio
										END,
										@IdEntidadCliente,
										IdTipoComprobante,
										Serie,
										Numero,
										DATEADD(HOUR, 3, GETDATE()),
										CAST(0 AS BIT),
										CAST(1 AS BIT),
										FechaEmision,
										CAST(0 AS BIT),
										NULL
										FROM ERP.Compra C
										WHERE ID = @IdComprobante

END
------=======================================================================------

------================ DISMINUIR PUNTO DECIMAL ================------
DECLARE @Total DECIMAL(14,2) = (SELECT ImporteSoles FROM @TableAsientoDetalle WHERE Identificador = 1);
DECLARE @IdDebeHaberTotal INT = (SELECT IdDebeHaber FROM @TableAsientoDetalle WHERE Identificador = 1);
DECLARE @TotalDetalle DECIMAL(14,2) = (SELECT SUM(CASE WHEN IdDebeHaber != @IdDebeHaberTotal THEN
													 ImporteSoles
												  ELSE 
													-ImporteSoles
												  END) FROM @TableAsientoDetalle WHERE IdAsiento = @IdAsiento AND Identificador != 1);  
DECLARE @TotalDiferencia DECIMAL(14,2) = 0;
DECLARE @Orden INT = 0;

IF @TotalDetalle != @Total
BEGIN
	SET @TotalDiferencia = @Total - @TotalDetalle;
	SET @Orden = (SELECT TOP 1 MAX(Identificador) FROM @TableAsientoDetalle WHERE IdAsiento = @IdAsiento AND IdDebeHaber != @IdDebeHaberTotal)
	UPDATE @TableAsientoDetalle SET ImporteSoles = ImporteSoles + @TotalDiferencia WHERE Identificador = @Orden;
END
------==============================================================------

------=======================GENERAR DESTINO PLAN CUENTA===================------

INSERT INTO @TableAsientoDetalle
SELECT
	@IdAsiento,
	(SELECT COUNT(1) FROM @TableAsientoDetalle) + AD.Orden,
	PC.ID AS IdPlanCuenta,
	AD.Nombre,
	CASE WHEN AD.IdTipoComprobante = 8 THEN ---NOTA CREDITO
		CASE WHEN DH.ID = 1 THEN
			2
		ELSE
			1
		END
	ELSE
		DH.ID
	END AS IdDebeHaber,
	CAST((PCD.Porcentaje * AD.ImporteSoles) / 100 AS DECIMAL(14,2)) AS ImporteSoles,
	CAST((PCD.Porcentaje * AD.ImporteDolares) / 100  AS DECIMAL(14,2)) AS ImporteDolares,
	AD.IdEntidad,
	AD.IdTipoComprobante,
	AD.Serie,
	AD.Documento,
	GETDATE(),
	CAST(0 AS BIT),
	CAST(1 AS BIT),
	AD.Fecha,
	CAST(1 AS BIT),
	CASE P.EstadoProyecto WHEN 1 THEN AD.IdProyecto ELSE NULL END AS IdProyecto
FROM ERP.PlanCuentaDestino PCD
INNER JOIN @TableAsientoDetalle AD ON PCD.IdPlanCuentaOrigen = AD.IdPlanCuenta
LEFT JOIN Maestro.DebeHaber DH ON DH.ID = 1 OR DH.ID = 2
LEFT JOIN ERP.PlanCuenta P ON P.ID = AD.IdPlanCuenta
INNER JOIN ERP.PlanCuenta PC ON CASE DH.ID WHEN 1 THEN PCD.IdPlanCuentaDestino1 ELSE PCD.IdPlanCuentaDestino2 END = PC.ID
SET NOCOUNT OFF;
------=======================================================================------

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
	SELECT IdAsiento,
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
	------=======================================================================------
SET NOCOUNT OFF;
END