CREATE PROC ERP.Usp_Sel_Nombre_Servicio
@IdEmpresa INT
AS
BEGIN
	
	SELECT DISTINCT Nombre 
	FROM ERP.Producto 
	WHERE IdEmpresa = @IdEmpresa AND IdTipoProducto = 2 

END