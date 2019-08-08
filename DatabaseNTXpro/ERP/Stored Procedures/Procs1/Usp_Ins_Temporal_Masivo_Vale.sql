CREATE PROCEDURE [ERP].[Usp_Ins_Temporal_Masivo_Vale]
@Item INT ,
@Nombre  VARCHAR(255),
@Cantidad DECIMAL(14,5),
@PrecioUnitario DECIMAL(14,5)
AS
--DECLARE @Item INT =2
--DECLARE @Nombre  VARCHAR(255)='LENTES STEELPRO'
--DECLARE @Cantidad DECIMAL(14,5)=2
--DECLARE @PrecioUnitario DECIMAL(14,5) =1.95
DECLARE @IdVale INT = 409
DECLARE @IdProducto INT = (SELECT ID FROM ERP.Producto  WHERE Nombre=@Nombre)
DECLARE @FlagAfecto BIT = 1
DECLARE @Fecha DATETIME = '2019-06-28 00:00:00.000'
DECLARE @NumeroLote VARCHAR(20) = 20557828495
DECLARE @SubTotal DECIMAL(14,5)= @PrecioUnitario*@Cantidad
DECLARE @IGV DECIMAL(14,5)=@SubTotal*0.18
DECLARE @Total DECIMAL(14,5)=@SubTotal+@IGV

	
				INSERT INTO [ERP].[ValeDetalle]
				 (
					 IdVale
					,Item
					,IdProducto
					,Nombre
					,FlagAfecto
					,Cantidad			
					,PrecioUnitario
					,SubTotal
					,IGV
					,Total
					,Fecha
					,NumeroLote
				 )
				 VALUES
				 (
				 @IdVale,
				 @Item,
				 @IdProducto,
				 @Nombre,
				 @FlagAfecto,
				 @Cantidad,
				 @PrecioUnitario,
				 @SubTotal,
				 @IGV,
				 @Total,
				 @Fecha,
				 @NumeroLote
				 )