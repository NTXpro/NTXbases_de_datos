CREATE PROC [ERP].[Usp_Ins_Producto]
@IdProducto INT OUT,
@IdEmpresa  INT  ,
@IdUnidadMedida INT ,
@IdExistencia INT  ,
@IdMarca INT  ,
@IdPlanCuenta INT,
@IdPlanCuentaCompra INT,
@FlagBorrador  BIT,
@Nombre VARCHAR(250),
@Peso DECIMAL(14,5),
@StockMinimo DECIMAL(14,5),
@StockDeseable DECIMAL(14,5),
@CodigoReferencia VARCHAR(50),
@UsuarioRegistro	VARCHAR(250),
@FlagISC		BIT,
@FlagIGVAfecto		BIT
AS
BEGIN

			INSERT INTO [ERP].[Producto] (IdEmpresa,Nombre,IdUnidadMedida,IdTipoProducto,IdExistencia,IdMarca,UsuarioRegistro,FechaRegistro,FlagBorrador,Flag,IdPlanCuenta,CodigoReferencia,FlagISC,FlagIGVAfecto,UsuarioModifico,FechaModificado,IdPlanCuentaCompra,Peso,StockMinimo,StockDeseable)VALUES (@IdEmpresa,@Nombre,@IdUnidadMedida,1,@IdExistencia,@IdMarca,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@FlagBorrador,1,@IdPlanCuenta,@CodigoReferencia,@FlagISC,@FlagIGVAfecto,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@IdPlanCuentaCompra,@Peso,@StockMinimo,@StockDeseable);
			SET @IdProducto = (SELECT CAST(SCOPE_IDENTITY() AS INT));

			DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(ID) FROM ERP.ListaPrecio WHERE IdEmpresa = @IdEmpresa)
			DECLARE @ListaPrecioTemp TABLE(INDICE INT,ID INT)

			INSERT INTO @ListaPrecioTemp
			SELECT ROW_NUMBER() OVER(ORDER BY ID ASC),ID FROM ERP.ListaPrecio WHERE IdEmpresa = @IdEmpresa
		
			DECLARE @i INT = 1;
			WHILE @i <= @TOTAL_ITEMS
			BEGIN
			
				DECLARE @IdListaPrecio INT = (SELECT ID FROM @ListaPrecioTemp WHERE INDICE = @i)

				INSERT INTO ERP.ListaPrecioDetalle(IdListaPrecio, IdProducto, PrecioUnitario, PorcentajeDescuento)
				VALUES (@IdListaPrecio, @IdProducto, CAST(1 AS DECIMAL(14,5)), 0)

				SET @i = @i + 1

			END
END