
create PROC [ERP].[Usp_Ins_AnticipoCompra]
@ID INT OUT,
@IdProveedor INT,
@IdEmpresa INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@IdPeriodo INT,
@TipoCambio DECIMAL(14,5),
@FechaEmision DATETIME,
@Serie VARCHAR(8),
@Documento VARCHAR(10),
@Descripcion VARCHAR(250),
@Total DECIMAL(14,5),
@Flag BIT,
@UsuarioRegistro VARCHAR(250)
AS
BEGIN

			INSERT INTO ERP.AnticipoCompra(IdProveedor,
									 IdEmpresa,
									 IdTipoComprobante,
									 IdMoneda,
									 IdPeriodo,
									 TipoCambio,
									 Serie,
									 Descripcion,
									 Total,
									 Flag,
									 UsuarioRegistro,
									 FechaRegistro,
									 FlagBorrador,
									 FechaEmision)
							  VALUES(CASE WHEN @IdProveedor = 0 THEN NULL ELSE @IdProveedor END,
								     @IdEmpresa,
									 @IdTipoComprobante,
									 @IdMoneda,
									 @IdPeriodo,
									 @TipoCambio,
									 @Serie,
									 @Descripcion,
									 @Total,
									 @Flag,
									 @UsuarioRegistro,
									 DATEADD(HOUR, 3, GETDATE()),
									 CAST(1 AS BIT),
									 @FechaEmision)

			SET @ID = CAST(SCOPE_IDENTITY() AS INT)


END
