
CREATE PROC [ERP].[Usp_Upd_Producto] 
@IdProducto INT,
@IdUnidadMedida INT,
@IdExistencia INT,
@IdMarca INT,
@IdPlanCuenta INT,
@IdPlanCuentaCompra INT,
@Nombre  VARCHAR(250),
@Peso DECIMAL(14,5),
@StockMinimo DECIMAL(14,5),
@StockDeseable DECIMAL(14,5),
@CodigoReferencia VARCHAR(50),
@FlagBorrador BIT,
@UsuarioModifico	VARCHAR(250),
@FlagISC BIT,
@FlagIGVAfecto BIT,
@Imagen VARBINARY(MAX),
@NombreImagen VARCHAR(150)
AS
BEGIN
	
	UPDATE [ERP].[Producto] SET IdUnidadMedida=@IdUnidadMedida, 
								IdExistencia = @IdExistencia , 
								IdMarca = @IdMarca , 
								Nombre = @Nombre ,
								Peso = @Peso,
								StockMinimo = @StockMinimo,
								StockDeseable = @StockDeseable,
								FlagBorrador = @FlagBorrador ,
								IdPlanCuenta=@IdPlanCuenta ,
								IdPlanCuentaCompra = @IdPlanCuentaCompra,
								CodigoReferencia =@CodigoReferencia,
								UsuarioModifico=@UsuarioModifico,
								FechaModificado=DATEADD(HOUR, 3, GETDATE()),
								FlagISC=@FlagISC,
								FlagIGVAfecto=@FlagIGVAfecto,
								Imagen = @Imagen,
								NombreImagen = @NombreImagen
								WHERE ID = @IdProducto 
				
				DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Producto WHERE ID = @IdProducto)
				DECLARE @IdProductoFamilia INT = (SELECT IdProducto FROM FamiliaProducto WHERE IdProducto =@IdProducto AND IdEmpresa = @IdEmpresa )

				IF(@FlagBorrador = 0 AND @IdProductoFamilia IS NULL )
				BEGIN
					INSERT INTO ERP.FamiliaProducto	(IdFamilia,IdProducto,IdEmpresa) VALUES(3,@IdProducto , @IdEmpresa)	
				END
END