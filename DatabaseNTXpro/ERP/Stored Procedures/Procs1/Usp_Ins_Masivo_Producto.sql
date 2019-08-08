CREATE PROC [ERP].[Usp_Ins_Masivo_Producto]

@IdUnidadMedida INT ,
@Nombre VARCHAR(250),
@Peso DECIMAL(14,5),
@CodigoReferencia VARCHAR(50)

AS
DECLARE @IdProducto INT = 0
DECLARE @IdEmpresa  INT = 1
DECLARE  @IdExistencia INT  = 1
DECLARE  @IdMarca INT  = 1
DECLARE @IdPlanCuenta INT = NULL
DECLARE @IdPlanCuentaCompra INT = NULL
DECLARE  @FlagBorrador  BIT= 0 
DECLARE @StockMinimo DECIMAL(14,5)= 0
DECLARE @StockDeseable DECIMAL(14,5) = 0
DECLARE @UsuarioRegistro VARCHAR(250)='NTXpro'
DECLARE @FlagISC BIT=0
DECLARE @FlagIGVAfecto BIT=1

IF exists (select p.Id from erp.producto p where p.CodigoReferencia=@CodigoReferencia OR P.Nombre=@Nombre)
BEGIN
   PRINT 'Producto Ya Existe En el ERP'+' | '+ @Nombre+' | '+'Con Codigo de Referencia'+' | '+@CodigoReferencia
END
ELSE
BEGIN
SET NOCOUNT ON
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
		    
            PRINT 'Nuevo Producto Registrado'+' | '+ @Nombre+' | '+'Con Codigo de Referencia'+' | '+@CodigoReferencia  

			
END