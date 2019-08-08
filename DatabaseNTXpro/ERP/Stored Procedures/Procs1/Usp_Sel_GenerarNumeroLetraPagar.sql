
create PROC [ERP].[Usp_Sel_GenerarNumeroLetraPagar]
@IdEmpresa INT,
@Serie VARCHAR(4)
AS
BEGIN
	DECLARE @UltimoNumero INT = ISNULL((SELECT MAX(Numero) FROM ERP.LetraPagar WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie), 0);

	SELECT (@UltimoNumero + 1)
END
