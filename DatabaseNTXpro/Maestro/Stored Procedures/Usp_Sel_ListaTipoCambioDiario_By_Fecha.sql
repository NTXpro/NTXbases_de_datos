CREATE PROC [Maestro].[Usp_Sel_ListaTipoCambioDiario_By_Fecha]
@anio int,
@mes int
AS
BEGIN
	
	SELECT ID,
			Fecha,
			VentaSunat,
			CompraSunat,
			VentaSBS,
			CompraSBS,
			VentaComercial,
			CompraComercial
	FROM ERP.TipoCambioDiario
	WHERE MONTH(Fecha) = @mes  AND YEAR(Fecha) = @anio

END