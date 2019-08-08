
CREATE PROC [ERP].[Usp_Ins_ProductoPropiedad]
@IdProducto INT,
@IdPropiedad INT,
@Valor VARCHAR(150)
AS
BEGIN

		/*ELINAMOS TODO PARA LUEGO VOLVERA A INSERTAR*/

		DELETE ERP.ProductoPropiedad WHERE IdProducto = @IdProducto AND IdPropiedad = @IdPropiedad 

		IF(@Valor IS NULL)
			BEGIN
				DELETE ERP.ProductoPropiedad WHERE IdProducto = @IdProducto AND IdPropiedad = @IdPropiedad 
			END

		/*INSERTAMOS EN LA TABLA*/

		INSERT INTO ERP.ProductoPropiedad(IdProducto,IdPropiedad,Valor)VALUES(@IdProducto,@IdPropiedad,@Valor)

END
