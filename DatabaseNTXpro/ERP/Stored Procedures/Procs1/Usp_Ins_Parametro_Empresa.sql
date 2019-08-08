
CREATE PROC [ERP].[Usp_Ins_Parametro_Empresa]
@IdEmpresa INT,
@IdEmpresaPlantilla INT
AS
BEGIN
	IF @IdEmpresa = 0 
	BEGIN
		SET @IdEmpresa = (SELECT TOP 1 ID FROM ERP.Empresa WHERE FlagPrincipal = 1)
	END

	DECLARE @IdPeriodo INT =(SELECT [ERP].[ObtenerIdPeriodo_By_Fecha](GETDATE())) 
	
	DECLARE @Valor_TCV VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'TCV' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('TIPO CAMBIO VENTA',@IdPeriodo,'TCV',@Valor_TCV,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_TCC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'TCC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('TIPO CAMBIO COMPRA',@IdPeriodo,'TCC',@Valor_TCC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCIGVV VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCIGVV' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA IGV VENTA',@IdPeriodo,'PCIGVV',@Valor_PCIGVV,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_ISC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'ISC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('IMPUESTO SELECTIVO AL CONSUMO',@IdPeriodo,'ISC',@Valor_ISC,2,GETDATE(),1,@IdEmpresa) 
	
	DECLARE @Valor_PP VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PP' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PORCENTAJE PERCEPCIÓN',@IdPeriodo,'PP',@Valor_PP,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCIGVC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCIGVC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA IGV COMPRA',@IdPeriodo,'PCIGVC',@Valor_PCIGVC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCISCC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCISCC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA ISC COMPRA',@IdPeriodo,'PCISCC',@Valor_PCISCC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCOIC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCOIC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA OI COMPRA',@IdPeriodo,'PCOIC',@Valor_PCOIC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCRSC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCRSC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA R+ COMPRA',@IdPeriodo,'PCRSC',@Valor_PCRSC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCRRC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCRRC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA R- COMPRA',@IdPeriodo,'PCRRC',@Valor_PCRRC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCDESC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCDESC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA DES COMPRA',@IdPeriodo,'PCDESC',@Valor_PCDESC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_CGPDC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'CGPDC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('CUENTA GANANCIA PARA DIFERENCIA DE CAMBIO',@IdPeriodo,'CGPDC',@Valor_CGPDC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_CPPDC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'CPPDC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('CUENTA PERDIDA PARA DIFERENCIA DE CAMBIO',@IdPeriodo,'CPPDC',@Valor_CPPDC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_VOD VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VOD' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTAS OBSERVACION DETRACCION',@IdPeriodo,'VOD',@Valor_VOD,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PMC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PMC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PERIODO MÁXIMO COMPRA',@IdPeriodo,'PMC',@Valor_PMC,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_PCIR VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCIR' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA IR COMPRA',@IdPeriodo,'PCIR',@Valor_PCIR,2,GETDATE(),1,@IdEmpresa) 

	DECLARE @Valor_ISPAD VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'ISPAD' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('INTERVALO DE SALDO PARA AJUSTE DE CUENTA',@IdPeriodo,'ISPAD',@Valor_ISPAD,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_CGPAC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'CGPAC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('CUENTA GANANCIA PARA AJUSTE DE CUENTA',@IdPeriodo,'CGPAC',@Valor_CGPAC,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_CPPAC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'CPPAC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('CUENTA PERDIDA PARA AJUSTE DE CUENTA',@IdPeriodo,'CPPAC',@Valor_CPPAC,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VPUII VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VPUII' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA PRECIO UNITARIO INCLUYE IGV',@IdPeriodo,'VPUII',@Valor_VPUII,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VDAAT VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VDAAT' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA DESCUENTO APLICA AL TOTAL',@IdPeriodo,'VDAAT',@Valor_VDAAT,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VMPU VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VMPU' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA MODIFICAR PRECIO UNITARIO',@IdPeriodo,'VMPU',@Valor_VMPU,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VTD VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VTD' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA TEXTO DEPARTAMENTAL',@IdPeriodo,'VTD',@Valor_VTD,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VCP VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VCP' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA CONCILIAR PRODUCTOS',@IdPeriodo,'VCP',@Valor_VCP,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_LRVCFP VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'LRVCFP' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('LOGISTICA REGISTRO DE VALE CON FECHAS PASADAS',@IdPeriodo,'LRVCFP',@Valor_LRVCFP,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_LIRSA VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'LIRSA' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('LOGISTICA IMPORTAR REQUERIMIENTOS SIN APROBACION',@IdPeriodo,'LIRSA',@Valor_LIRSA,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VCR VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VCR' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA CONTROLAR CORRELATIVO',@IdPeriodo,'VCR',@Valor_VCR,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VCSP VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VCSP' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA CONTROLAR STOCK PRODUCTOS',@IdPeriodo,'VCSP',@Valor_VCSP,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_LCOC VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'LCOC' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('LOGISTICA CONDICION ORDEN DE COMPRA',@IdPeriodo,'LCOC',@Valor_LCOC,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VPTDA VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VPTDA' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA PARSEAR TOTAL DE DETRACCION A ENTERO',@IdPeriodo,'VPTDA',@Valor_VPTDA,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_RRHHSM VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'RRHHSM' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('RRHH SUELDO MINIMO',@IdPeriodo,'RRHHSM',@Valor_RRHHSM,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_RRHHPAS VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'RRHHPAS' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('RRHH PORCENTAJE ASIGNACION FAMILIAR',@IdPeriodo,'RRHHPAS',@Valor_RRHHPAS,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_LTPL VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'LTPL' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('LOGISTICA TOMAR PRECIO LISTA',@IdPeriodo,'LTPL',@Valor_LTPL,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_PCIMS VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'PCIMS' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('PLAN CUENTA IMS COMPRA',@IdPeriodo,'PCIMS',@Valor_PCIMS,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_IDCCT VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'IDCCT' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('IMPUESTO DE CUARTA CATEGORIA',@IdPeriodo,'IDCCT',@Valor_IDCCT,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_IDSCT VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'IDSCT' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('IMPUESTO DE SEGUNDA CATEGORIA',@IdPeriodo,'IDSCT',@Valor_IDSCT,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_CPTDA VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'CPTDA' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('COMPRA PARSEAR TOTAL DE DETRACCION A ENTERO',@IdPeriodo,'CPTDA',@Valor_CPTDA,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VNR VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VNR' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA NOMBRE REPORTE',@IdPeriodo,'VNR',@Valor_VNR,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_VPU2 VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'VPU2' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('VENTA PRECIO UNITARIO 2 DECIMALES',@IdPeriodo,'VPU2',@Valor_VPU2,2,GETDATE(),1,@IdEmpresa)

	DECLARE @Valor_CRT VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'CRT' AND IdEmpresa = @IdEmpresaPlantilla)
	INSERT INTO ERP.Parametro(Nombre, IdPeriodo, Abreviatura, Valor, IdTipoParametro, FechaRegistro, Flag, IdEmpresa)
	VALUES('COTIZACION REPORTE TICKET',@IdPeriodo,'CRT',@Valor_CRT,2,GETDATE(),1,@IdEmpresa)
END
