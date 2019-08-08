
CREATE PROCEDURE [ERP].[Usp.ValidarCuentaPagar] --4,1,2,'4354','43653656'
@IdProveedor INT,
@IdMoneda INT,
@IdTipoComprobante INT,
@Serie VARCHAR(50),
@Documento VARCHAR(50)
AS
BEGIN
	SELECT  CP.ID,
			CPO.Nombre
	FROM ERP.CuentaPagar CP
	INNER JOIN Maestro.CuentaPagarOrigen CPO
	ON CPO.ID = CP.IdCuentaPagarOrigen
	INNER JOIN ERP.Entidad ENT
	ON ENT.ID = CP.IdEntidad
	INNER JOIN ERP.Proveedor PRO
	ON PRO.IdEntidad = ENT.ID
	WHERE PRO.ID = @IdProveedor AND CP.IdMoneda = @IdMoneda AND CP.Serie = @Serie AND CP.Numero = @Documento AND CP.Flag = 1 AND CP.IdTipoComprobante = @IdTipoComprobante
END
