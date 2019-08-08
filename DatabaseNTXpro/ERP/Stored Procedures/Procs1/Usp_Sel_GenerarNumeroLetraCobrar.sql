
CREATE PROC [ERP].[Usp_Sel_GenerarNumeroLetraCobrar]
@IdEmpresa INT,
@Serie VARCHAR(4)
AS
BEGIN
	DECLARE @UltimoNumero INT = ISNULL((SELECT MAX(Numero) FROM ERP.LetraCobrar WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie), 0);

	SELECT (@UltimoNumero + 1)
END
