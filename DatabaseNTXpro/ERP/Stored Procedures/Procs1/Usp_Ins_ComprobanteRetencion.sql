
CREATE PROCEDURE ERP.Usp_Ins_ComprobanteRetencion
@IdEmpresa INT,
@IdCliente INT,
@Serie CHAR(4),
@Documento VARCHAR(20),
@FechaEmision DATETIME,
@TipoCambio DECIMAL(14, 5),
@ImportePago DECIMAL(14,5 ),
@ImporteRetenido DECIMAL(14, 5),
@FlagBorrador BIT,
@Flag BIT,
@UsuarioRegistro VARCHAR(250),
@ID INT OUTPUT
AS
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

	INSERT INTO ERP.ComprobanteRetencion
	(	
		IdEmpresa,
		IdCliente,		
		Serie,
		Documento,
		FechaEmision,
		TipoCambio,
		ImportePago,
		ImporteRetenido,
		FlagBorrador,
		Flag,
		UsuarioRegistro,
		FechaRegistro,
		UsuarioModifico,
		FechaModifico,
		UsuarioAnulo,
		FechaAnulo
	)
	VALUES
	(
		@IdEmpresa,
		@IdCliente,		
		@Serie,
		@Documento,
		@FechaEmision,
		@TipoCambio,
		@ImportePago,
		@ImporteRetenido,
		@FlagBorrador,
		@Flag,
		@UsuarioRegistro,
		@FechaActual,
		NULL, --UsuarioModifico
		NULL, --FechaModifico
		NULL, --UsuarioAnulo,
		NULL --FechaAnulo
	)

	SELECT @ID = SCOPE_IDENTITY()
