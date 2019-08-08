  CREATE PROC [ERP].[Usp_Upd_Percepcion]
  @IdPercepcion INT ,
  @FechaPercepcion DATETIME,
  @IdTipoPercepcion INT,
  @Serie CHAR(4),
  @Documento VARCHAR(20),
  @Importe DECIMAL(14,5)
  AS
  BEGIN

			UPDATE ERP.Percepcion SET	
										Fecha=@FechaPercepcion,
										IdTipoPercepcion=@IdTipoPercepcion,
										Serie=@Serie,
										Documento=@Documento,
										Importe=@Importe WHERE ID=@IdPercepcion

  END
