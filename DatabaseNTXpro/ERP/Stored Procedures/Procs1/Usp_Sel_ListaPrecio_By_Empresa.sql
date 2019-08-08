CREATE PROC [ERP].[Usp_Sel_ListaPrecio_By_Empresa]
@IdEmpresa INT
AS
BEGIN
		SELECT
				ID,
				Nombre
		FROM ERP.ListaPrecio
		WHERE FlagBorrador = 0 AND Flag = 1 AND IdEmpresa = @IdEmpresa

END