CREATE PROCEDURE [ERP].[Usp.ValidarRegistroCompra]
@IdProveedor INT,
@IdMoneda INT,
@IdTipoComprobante INT,
@Serie VARCHAR(50),
@Documento VARCHAR(50)
AS
BEGIN
	SELECT DISTINCT  CO.ID,
		   AN.Nombre  Anio,
		   ME.Nombre  Mes
	FROM ERP.Compra CO
	LEFT JOIN ERP.Periodo PE
	ON PE.ID = CO.IdPeriodo
	LEFT JOIN Maestro.Anio AN
	ON AN.ID = PE.IdAnio
	LEFT JOIN Maestro.Mes ME
	ON ME.ID = PE.IdMes
	WHERE CO.IdProveedor = @IdProveedor AND CO.IdMoneda = @IdMoneda AND CO.Serie = @Serie 
	AND CO.Numero = @Documento AND CO.FlagBorrador =0 AND CO.Flag = 1 AND CO.IdTipoComprobante = @IdTipoComprobante AND CO.IdTipoComprobante NOT IN (SELECT ID FROM PLE.T10TipoComprobante WHERE Nombre LIKE 'AN'+ '%')
END
