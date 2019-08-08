
CREATE PROC [ERP].[Usp_Ins_ListaPrecio_Empresa]
@IdEmpresa INT
AS
BEGIN
	
	INSERT INTO ERP.ListaPrecio(Nombre, IdEmpresa, IdMoneda, PorcentajeDescuento, FechaRegistro, FlagBorrador, Flag, FlagPrincipal)
	VALUES('LISTA PRINCIPAL SOLES', @IdEmpresa, 1, 0, GETDATE(), 0, 1, 1) 

	INSERT INTO ERP.ListaPrecio(Nombre, IdEmpresa, IdMoneda, PorcentajeDescuento, FechaRegistro, FlagBorrador, Flag, FlagPrincipal)
	VALUES('LISTA PRINCIPAL DOLARES', @IdEmpresa, 2, 0, GETDATE(), 0, 1, 1) 
END

