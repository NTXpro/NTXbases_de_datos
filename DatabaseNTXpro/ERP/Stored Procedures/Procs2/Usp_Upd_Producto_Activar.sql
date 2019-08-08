CREATE PROC [ERP].[Usp_Upd_Producto_Activar]
@IdProducto			INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Producto SET Flag = 1, FechaActivacion =DATEADD(HOUR, 3, GETDATE()),UsuarioActivo=@UsuarioActivo  WHERE ID = @IdProducto AND IdTipoProducto= 1
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Producto WHERE ID = @IdProducto)
	INSERT INTO ERP.FamiliaProducto	(IdFamilia,IdProducto,IdEmpresa) VALUES(3,@IdProducto , @IdEmpresa)	
END
