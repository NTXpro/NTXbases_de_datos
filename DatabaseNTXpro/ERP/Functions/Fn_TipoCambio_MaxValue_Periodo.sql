CREATE FUNCTION [ERP].[Fn_TipoCambio_MaxValue_Periodo]
(    
    @IdAnio INT
)
RETURNS @ReturnValue TABLE 
(
    ID INT IDENTITY PRIMARY KEY,
    Valor DECIMAL(14,5),
	Fecha DATETIME,
	VentaSunat DECIMAL(14,5),
	CompraSunat DECIMAL(14,5)
) 
AS
BEGIN
	INSERT INTO  @ReturnValue
	SELECT 
		TIPO_CAMBIO.Valor, 
		TIPO_CAMBIO.Fecha, 
		TP.VentaSunat,
		TP.CompraSunat
	FROM 
	(SELECT MONTH(Fecha) AS Valor, MAX(Fecha) AS Fecha
	 FROM ERP.TipoCambioDiario
	 GROUP BY YEAR(Fecha), MONTH(Fecha)
	 HAVING
	 YEAR(Fecha) = (SELECT CAST(Nombre AS INT) FROM Maestro.Anio WHERE ID = @IdAnio)) TIPO_CAMBIO
	 INNER JOIN ERP.TipoCambioDiario TP ON TIPO_CAMBIO.Fecha = TP.Fecha	
    RETURN;
END
