

CREATE PROC [ERP].[Usp_Sel_Trabajador_By_Documento]
@IdTipoDocumento INT,
@NumeroDocumento VARCHAR(20)
AS
BEGIN
	SELECT		
			T.ID,
			P.Nombre,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
			'Jr. Preciados' AS "Direccion",
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			EN.Nombre AS "NombreCompleto"
	FROM ERP.Trabajador T
	INNER JOIN ERP.Entidad EN
		ON EN.ID = T.IdEntidad
	INNER JOIN ERP.Persona P
		ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
WHERE ETD.IdTipoDocumento = @IdTipoDocumento AND ETD.NumeroDocumento = @NumeroDocumento AND T.Flag = 1 AND T.FlagBorrador = 0
END
