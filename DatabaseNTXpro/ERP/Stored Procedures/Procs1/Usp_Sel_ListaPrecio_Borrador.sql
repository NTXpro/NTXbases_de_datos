
CREATE PROC [ERP].[Usp_Sel_ListaPrecio_Borrador]
@IdEmpresa INT
AS
BEGIN
	
	SELECT	ID,
			NOMBRE,
			IdMoneda,
			PorcentajeDescuento,
			FechaRegistro
	FROM ERP.ListaPrecio 
	WHERE FlagBorrador = 1 AND IdEmpresa = @IdEmpresa

END