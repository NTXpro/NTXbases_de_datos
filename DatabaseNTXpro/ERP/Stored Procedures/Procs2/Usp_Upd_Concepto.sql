CREATE PROCEDURE [ERP].[Usp_Upd_Concepto]
@ID INT,
@IdEmpresa INT,
@IdTipoConcepto INT,
@IdClase INT,
@IdIngresoTributoDescuento INT,
@Nombre VARCHAR(250),
@Abreviatura VARCHAR(50),
@PorDefecto decimal(18,2),
@FlagSiemprePlanilla bit,
@FlagEstructuraPlanilla bit,
@UsuarioModifico varchar(250),
@FechaModificado datetime,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
    DECLARE @ORDEN_GENERADA INT = (SELECT MAX(ISNULL(Orden, 0)) + 1 FROM ERP.Concepto WHERE IdEmpresa = @IdEmpresa AND IdTipoConcepto = @IdTipoConcepto);
	DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [ERP].[Concepto] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre)) AND IdTipoConcepto = @IdTipoConcepto AND ID != @ID AND IdEmpresa = @IdEmpresa)

	IF(@EXISTE = 0)
	BEGIN
		UPDATE [ERP].[Concepto] SET 
			[IdTipoConcepto] = (CASE @IdTipoConcepto WHEN 0 THEN NULL ELSE @IdTipoConcepto END),
			[IdClase] = (CASE @IdClase WHEN 0 THEN NULL ELSE @IdClase END),
			[IdIngresoTributoDescuento] = (CASE @IdIngresoTributoDescuento WHEN 0 THEN NULL ELSE @IdIngresoTributoDescuento END),
			[Orden] = (CASE @FlagBorrador WHEN 1 THEN NULL ELSE (CASE WHEN [Orden] > 0 THEN [Orden] ELSE @ORDEN_GENERADA END) END),
			[Nombre] = @Nombre,
			[Abreviatura] = @Abreviatura,
			[PorDefecto] = @PorDefecto,
			[FlagSiemprePlanilla] = @FlagSiemprePlanilla,
			[FlagEstructuraPlanilla] = @FlagEstructuraPlanilla,
			[UsuarioModifico] = @UsuarioModifico,
			[FechaModificado] = @FechaModificado,
			[FlagBorrador] = @FlagBorrador,
			[Flag] = @Flag
		WHERE ID = @ID
		SELECT @ID;
	END
	ELSE
	BEGIN
		SELECT -1;
	END
END
