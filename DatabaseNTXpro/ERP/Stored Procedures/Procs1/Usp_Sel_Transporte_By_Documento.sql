
CREATE PROC [ERP].[Usp_Sel_Transporte_By_Documento]
@IdEmpresa INT,
@IdTipoDocumento INT,
@NumeroDocumento VARCHAR(20)
AS
BEGIN
	SELECT		
			TR.ID,
			P.Nombre,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
			E.Direccion + ISNULL((' - ' + U.Nombre + ' - ' + (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + ' - ' + (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))),'') AS "Direccion",
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			EN.Nombre AS "NombreCompleto"
	FROM ERP.Transporte TR
	INNER JOIN ERP.Entidad EN
		ON EN.ID = TR.IdEntidad
	INNER JOIN ERP.Establecimiento E
		ON E.IdEntidad = EN.ID
	LEFT JOIN ERP.Persona P
		ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = E.IdUbigeo
WHERE ETD.IdTipoDocumento = @IdTipoDocumento AND ETD.NumeroDocumento = @NumeroDocumento AND TR.IdEmpresa = @IdEmpresa AND TR.Flag = 1 AND TR.FlagBorrador = 0
END
