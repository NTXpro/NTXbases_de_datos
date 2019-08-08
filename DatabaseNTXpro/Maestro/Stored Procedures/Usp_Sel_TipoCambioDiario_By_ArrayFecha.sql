CREATE PROC [Maestro].[Usp_Sel_TipoCambioDiario_By_ArrayFecha]--'12/12/2016'
@Fecha VARCHAR(MAX)
AS
BEGIN

	SELECT 
		ID,
		Fecha, 
		VentaSunat
	FROM 
	ERP.TipoCambioDiario 
	WHERE 
	Fecha IN (SELECT CONVERT(DATETIME, DATA, 103) AS FECHA FROM [ERP].[Fn_SplitContenido] (@Fecha, ','))

	UNION

	SELECT 
		ID,
		Fecha, 
		VentaSunat
	FROM 
	ERP.TipoCambioDiario 
	WHERE
	Fecha = (SELECT DISTINCT MAX(Fecha) FROM ERP.TipoCambioDiario)

END