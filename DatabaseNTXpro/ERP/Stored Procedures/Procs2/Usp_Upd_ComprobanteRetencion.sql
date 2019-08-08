
CREATE PROCEDURE ERP.Usp_Upd_ComprobanteRetencion
@ID INT,
@IdEmpresa INT,
@IdCliente INT,
@Serie CHAR(4),
@Documento VARCHAR(20),
@FechaEmision DATETIME,
@TipoCambio DECIMAL(14, 5),
@ImportePago DECIMAL(14,5),
@ImporteRetenido DECIMAL(14, 5),
@FlagBorrador BIT,
@Flag BIT,
@UsuarioModifico VARCHAR(250)
AS
	
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

	UPDATE ERP.ComprobanteRetencion
	SET IdEmpresa = @IdEmpresa,
		IdCliente = @IdCliente,
		Serie = @Serie,
		Documento = @Documento,
		FechaEmision = @FechaEmision,
		TipoCambio = @TipoCambio,
		ImportePago = @ImportePago,
		ImporteRetenido = @ImporteRetenido,
		FlagBorrador = @FlagBorrador,
		Flag = @Flag,
		UsuarioModifico = @UsuarioModifico,
		FechaModifico = @FechaActual
	WHERE ID = @ID
