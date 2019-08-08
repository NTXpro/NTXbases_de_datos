﻿CREATE PROC [dbo].[EJEMPLOSINS]
@DOCUMENTO NVARCHAR(50)
,@MONTO INT
,@IDPRO INT

AS
		  DECLARE @IdPedido INT=(SELECT PD.ID
											 FROM ERP.Pedido PD
											 INNER JOIN ERP.Cliente CL
											 ON CL.ID=PD.IdCliente
											 INNER JOIN ERP.Entidad E
											 ON CL.IdEntidad=E.ID
											 INNER JOIN ERP.EntidadTipoDocumento ETP
											 ON E.ID=ETP.IdEntidad
											 WHERE  PD.FECHA = '2019-01-01 00:00:00.000'
											 and ETP.NumeroDocumento=@DOCUMENTO)
			DECLARE @IdProducto INT=@IDPRO
			DECLARE @Nombre NVARCHAR(MAX)=(SELECT Nombre FROM ERP.Producto WHERE ID=@IDPRO) 
			DECLARE @Cantidad INT=1
			DECLARE @PorcentajeDescuento INT=0
			DECLARE @PorcentajeISC INT=0
			DECLARE @PrecioPromedio INT=0
			DECLARE @PrecioUnitarioLista INT=@MONTO
			DECLARE @PrecioUnitarioListaSinIGV INT=@MONTO
			DECLARE @PrecioUnitarioValorISC INT=0
			DECLARE @PrecioUnitarioISC INT=0
			DECLARE @PrecioUnitarioDescuento INT=0
			DECLARE @PrecioUnitarioSubTotal INT=@MONTO
			DECLARE @PrecioUnitarioIGV INT=@MONTO
			DECLARE @PrecioUnitarioTotal INT=@MONTO
			DECLARE @PrecioLista INT=@MONTO
	    	DECLARE @FlagISC BIT=0
			DECLARE @FlagAfecto BIT=0
			DECLARE @FlagGratuito BIT=0
			DECLARE @PrecioDescuento INT=0
			DECLARE @PrecioSubTotal INT=1
			DECLARE @PrecioIGV INT=0
			DECLARE @PrecioTotal INT=@MONTO
			DECLARE @FechaRegistro DATETIME='2019-01-01 00:00:00.000'


   INSERT INTO [ERP].[PedidoDetalle]
    (
	       IdPedido
			,IdProducto 
			,Nombre
			,Cantidad  
			,PorcentajeDescuento
			,PorcentajeISC
			,PrecioPromedio
			,PrecioUnitarioLista
			,PrecioUnitarioListaSinIGV
			,PrecioUnitarioValorISC
			,PrecioUnitarioISC
			,PrecioUnitarioDescuento
			,PrecioUnitarioSubTotal
			,PrecioUnitarioIGV
			,PrecioUnitarioTotal
			,PrecioLista
			,FlagISC
			,FlagAfecto
			,FlagGratuito
			,PrecioDescuento
			,PrecioSubTotal
			,PrecioIGV
			,PrecioTotal
			,FechaRegistro
	)
	VALUES 
	(
	         @IdPedido  
			,@IdProducto 
			,@Nombre 
			,@Cantidad  
			,@PorcentajeDescuento 
			,@PorcentajeISC 
			,@PrecioPromedio 
			,@PrecioUnitarioLista 
			,@PrecioUnitarioListaSinIGV 
			,@PrecioUnitarioValorISC 
			,@PrecioUnitarioISC 
			,@PrecioUnitarioDescuento 
			,@PrecioUnitarioSubTotal 
			,@PrecioUnitarioIGV 
			,@PrecioUnitarioTotal 
			,@PrecioLista 
			,@FlagISC 
			,@FlagAfecto 
			,@FlagGratuito 
			,@PrecioDescuento 
			,@PrecioSubTotal 
			,@PrecioIGV 
			,@PrecioTotal 
			,@FechaRegistro 
	);