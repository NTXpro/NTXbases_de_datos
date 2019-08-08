
CREATE PROCEDURE ERP.Sel_Cliente_Agente_Select
AS
	SELECT C.ID, EN.Nombre, ETD.NumeroDocumento AS 'RUC'
	FROM ERP.Cliente C
	INNER JOIN ERP.Entidad EN ON C.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD ON EN.ID = ETD.IdEntidad
	WHERE C.Flag = 1
	AND C.FlagBorrador = 0
	--AND EN.AgenteRetencion = 1
