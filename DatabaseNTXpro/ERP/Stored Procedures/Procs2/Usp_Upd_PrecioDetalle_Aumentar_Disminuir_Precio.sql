CREATE PROC ERP.Usp_Upd_PrecioDetalle_Aumentar_Disminuir_Precio-- 4,20,'-'
@IdListaPrecio INT,
@Porcentaje INT,
@TipoOperacion VARCHAR(2)
AS
BEGIN
	

	IF @TipoOperacion = '+'
		BEGIN
			UPDATE ERP.ListaPrecioDetalle SET PrecioUnitario = PrecioUnitario + (PrecioUnitario * @Porcentaje/100)
			WHERE IdListaPrecio = @IdListaPrecio
		END
	ELSE 
		BEGIN
			UPDATE ERP.ListaPrecioDetalle SET PrecioUnitario = PrecioUnitario - (PrecioUnitario * @Porcentaje/100)
			WHERE IdListaPrecio = @IdListaPrecio
		END
END




