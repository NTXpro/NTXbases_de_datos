

CREATE PROC [ERP].[Usp_Ins_Servicio]
@IdProducto INT OUT,
@IdEmpresa  INT  ,
@IdPlanCuenta INT,
@FlagBorrador  BIT,
@Nombre VARCHAR(50),
@CodigoReferencia VARCHAR(50),
@UsuarioRegistro	VARCHAR(250),
@FlagISC BIT,
@FlagIGVAfecto BIT
AS
BEGIN
--BEGIN TRAN
--	BEGIN TRY;

			INSERT INTO [ERP].[Producto] (IdEmpresa,Nombre,IdUnidadMedida,IdTipoProducto,IdExistencia,IdMarca,UsuarioRegistro,FechaRegistro,FlagBorrador,Flag,IdPlanCuenta,CodigoReferencia,FlagISC,FlagIGVAfecto)
								  VALUES (@IdEmpresa,@Nombre,59,2,1,1,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@FlagBorrador,1,@IdPlanCuenta,@CodigoReferencia,@FlagISC,@FlagIGVAfecto);
			SET @IdProducto = (SELECT CAST(SCOPE_IDENTITY() AS int));
			
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


	--	COMMIT TRAN
	--END TRY
	--BEGIN CATCH 
	--		ROLLBACK TRAN
	--END CATCH
END
