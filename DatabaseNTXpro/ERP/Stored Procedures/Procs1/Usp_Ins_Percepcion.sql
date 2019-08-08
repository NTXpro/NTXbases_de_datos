  CREATE PROC [ERP].[Usp_Ins_Percepcion]
  @IdPercepcion INT OUT,
  @IdCompra INT,
  @FechaPercepcion DATETIME,
  @IdTipoComprobante INT,
  @IdTipoPercepcion INT,
  @Serie CHAR(4),
  @Documento VARCHAR(20),
  @Importe DECIMAL(14,5)
  AS
  BEGIN

			INSERT INTO ERP.Percepcion (IdCompra,
										Fecha,
										IdTipoComprobante,
										IdTipoPercepcion,
										Serie,
										Documento,
										Importe
										)
							VALUES(	@IdCompra,
										@FechaPercepcion,
										@IdTipoComprobante,
										@IdTipoPercepcion,
										@Serie,
										@Documento,
										@Importe)

			SET @IdPercepcion = (SELECT CAST(SCOPE_IDENTITY() AS int));
  END
