

CREATE PROC [ERP].[Usp_Upd_OrdenPago]
@IdOrdenPago INT,
@IdProyecto INT,
@IdEntidad INT,
@IdMoneda INT,
@IdEmpresa INT,
@Fecha DATETIME,
@Serie VARCHAR(4),
@Descripcion VARCHAR(max),
@TipoCambio DECIMAL(14, 5),
@Total DECIMAL(14, 5),
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
	
	UPDATE ERP.OrdenPago SET
		IdProyecto = IIF(@IdProyecto = 0, null, @IdProyecto),
		IdEntidad = IIF(@IdEntidad = 0, null, @IdEntidad),
		IdMoneda = IIF(@IdMoneda = 0, null, @IdMoneda),
		IdEmpresa = @IdEmpresa,
		Fecha = @Fecha,
		Descripcion = @Descripcion,
		TipoCambio = @TipoCambio,
		Total = @Total,
		FechaModificado = @FechaActual,
		UsuarioModifico = @UsuarioModifico,
		FlagBorrador = @FlagBorrador,
		Serie = @Serie,
		Documento = @Documento
	WHERE ID = @IdOrdenPago

END