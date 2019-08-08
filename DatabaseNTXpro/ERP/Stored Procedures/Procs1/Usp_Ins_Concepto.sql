
CREATE PROC [ERP].[Usp_Ins_Concepto]
@IdEmpresa INT,
@IdTipoConcepto INT,
@IdClase INT,
@IdIngresoTributoDescuento INT,
@Nombre VARCHAR(250),
@Abreviatura VARCHAR(50),
@PorDefecto decimal(18,2),
@FlagSiemprePlanilla bit,
@FlagEstructuraPlanilla bit,
@UsuarioRegistro varchar(250),
@FechaRegistro datetime,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	DECLARE @ORDEN_GENERADA INT;
	DECLARE @ORDEN_EXISTENTE INT = (SELECT COUNT(1) FROM ERP.Concepto )
	
	IF(@ORDEN_EXISTENTE > 0)
	BEGIN
		SET @ORDEN_GENERADA = (SELECT MAX(ISNULL(Orden, 0)) + 1 FROM ERP.Concepto WHERE   IdTipoConcepto = @IdTipoConcepto);
     
	END
	ELSE
	BEGIN
		SET @ORDEN_GENERADA = 1;
	END
	
	DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [ERP].[Concepto] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre)) AND IdTipoConcepto = @IdTipoConcepto)
	DECLARE @ID_CONCEPTO INT;

	IF(@EXISTE = 0)
	BEGIN
		INSERT INTO [ERP].[Concepto]
			   ([IdEmpresa]
			   ,[IdTipoConcepto]
			   ,[IdClase]
			   ,[IdIngresoTributoDescuento]
			   ,[Orden]
			   ,[Nombre]
			   ,[Abreviatura]
			   ,[PorDefecto]
			   ,[FlagSiemprePlanilla]
			   ,[FlagEstructuraPlanilla]
			   ,[UsuarioRegistro]
			   ,[FechaRegistro]
			   ,[FlagBorrador]
			   ,[Flag])
		VALUES
			   (@IdEmpresa,
			   (CASE @IdTipoConcepto WHEN 0 THEN NULL ELSE @IdTipoConcepto END),
			   (CASE @IdClase WHEN 0 THEN NULL ELSE @IdClase END),
			   (CASE @IdIngresoTributoDescuento WHEN 0 THEN NULL ELSE @IdIngresoTributoDescuento END),
			   (CASE @FlagBorrador WHEN 1 THEN NULL ELSE @ORDEN_GENERADA END),
			   @Nombre,
			   @Abreviatura,
			   @PorDefecto,
			   @FlagSiemprePlanilla,
			   @FlagEstructuraPlanilla,
			   @UsuarioRegistro,
			   @FechaRegistro,
			   @FlagBorrador,
			   @Flag)
		SELECT CAST(SCOPE_IDENTITY() AS INT)
	END
	ELSE
	BEGIN
		SELECT -1
	END
END
