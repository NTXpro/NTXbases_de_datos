
CREATE PROC [ERP].[Usp_Ins_OrdenPago]
@IdOrdenPago INT OUT,
@IdProyecto INT,
@IdEntidad INT,
@IdMoneda INT,
@IdEmpresa INT,
@Fecha DATETIME,
@Serie VARCHAR(4),
@Descripcion VARCHAR(max),
@TipoCambio DECIMAL(14, 5),
@Total DECIMAL(14, 5),
@UsuarioRegistro VARCHAR(250),
@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
	DECLARE @Documento VARCHAR(20) = (SELECT Documento FROM ERP.OrdenPago WHERE ID = @IdOrdenPago);
	IF @FlagBorrador = 0 AND @Documento IS NULL
	BEGIN
		DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.OrdenPago WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie AND FlagBorrador = 0);
			IF @UltimoCorrelativoGenerado IS NULL 
				BEGIN
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(1)), 8)
				END
			ELSE
				BEGIN
					SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8)
				END
	END
	
	INSERT INTO ERP.OrdenPago(IdProyecto
							  ,IdEntidad
							  ,IdMoneda
							  ,IdEmpresa
							  ,Fecha
							  ,Descripcion
							  ,TipoCambio
							  ,Total
							  ,UsuarioRegistro
							  ,FechaRegistro
							  ,FechaModificado
							  ,UsuarioModifico
							  ,Flag
							  ,FlagBorrador
							  ,Serie
							  ,Documento
	)VALUES(
							   IIF(@IdProyecto = 0, null, @IdProyecto)
							  ,IIF(@IdEntidad = 0, null, @IdEntidad)
							  ,IIF(@IdMoneda = 0, null, @IdMoneda)
							  ,IIF(@IdEmpresa = 0, null, @IdEmpresa)
							  ,@Fecha
							  ,@Descripcion
							  ,@TipoCambio
							  ,@Total
							  ,@UsuarioRegistro
							  ,@FechaActual
							  ,@FechaActual
							  ,@UsuarioModifico
							  ,CAST(1 AS BIT)
							  ,@FlagBorrador
							  ,@Serie
							  ,@Documento)

	SET @IdOrdenPago = SCOPE_IDENTITY();

END