

CREATE PROC [ERP].[Usp_Ins_DatoLaboralPrestamo]
@IdPrestamo INT OUT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdConcepto INT,
@Cuotas DECIMAL(14,5),
@Monto DECIMAL(14,5),
@Descuento DECIMAL(14,5),
@FechaPrestamo DATETIME,
@FechaDescuento DATETIME
AS
BEGIN
	DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);

	IF(@FechaPrestamo >= @FECHA_INICIO_LABORAL AND @FechaDescuento >= @FECHA_INICIO_LABORAL)
	BEGIN
			INSERT INTO ERP.DatoLaboralPrestamo(
										IdDatoLaboral,
										IdEmpresa,
										IdConcepto,
										Cuotas,
										Monto,
										Descuento,
										FechaPrestamo,
										FechaDescuento
									)
									VALUES(
											@IdDatoLaboral,
											@IdEmpresa,
											@IdConcepto,
											@Cuotas,
											@Monto,
											@Descuento,
											@FechaPrestamo,
											@FechaDescuento
											)
				SET @IdPrestamo = SCOPE_IDENTITY();

				SELECT @IdPrestamo
	END
	ELSE
	BEGIN
		SET @IdPrestamo = -1;
		SELECT @IdPrestamo;
	END
END
