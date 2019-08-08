
CREATE PROC [ERP].[Usp_Ins_Gasto]
@ID INT OUT,
@IdProveedor INT,
@IdEmpresa INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@IdPeriodo INT,
@IdProyecto INT,
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

			INSERT INTO ERP.Gasto(IdProveedor,
								  IdProyecto,
								  IdEmpresa,
								  IdTipoComprobante,
								  IdMoneda,
								  IdPeriodo,
								  TipoCambio,
								  Serie,
								  Documento,
								  Descripcion,
								  Total,Flag,
								  UsuarioRegistro,
								  FechaRegistro,
								  FlagBorrador,
								  FechaEmision)
						   VALUES(
								  CASE WHEN @IdProveedor = 0 THEN
											NULL
								  ELSE
											@IdProveedor
								  END,
								  CASE WHEN @IdProyecto = 0 THEN
											NULL
								  ELSE
											@IdProyecto
								  END,
							      @IdEmpresa,
								  @IdTipoComprobante,
								  @IdMoneda,
								  @IdPeriodo,
								  @TipoCambio,
								  @Serie,
								  @Documento,
								  @Descripcion,
								  @Total,
								  @Flag,
								  @UsuarioRegistro,
								  DATEADD(HOUR, 3, GETDATE()),
								  1,
								  @FechaEmision)

			SET @ID = CAST(SCOPE_IDENTITY() AS INT)


END
