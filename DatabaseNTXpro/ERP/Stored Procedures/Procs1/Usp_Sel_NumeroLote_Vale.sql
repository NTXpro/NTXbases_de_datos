
create PROC ERP.Usp_Sel_NumeroLote_Vale
@IdEmpresa INT,
@IdProducto INT,
@Fecha DATETIME
AS
BEGIN
	SELECT [ERP].[GenerarNumeroLoteValeDetalle](@IdEmpresa,@IdProducto,@Fecha)
END
