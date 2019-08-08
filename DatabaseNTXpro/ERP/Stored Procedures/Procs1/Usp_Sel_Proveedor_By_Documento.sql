
CREATE PROC [ERP].[Usp_Sel_Proveedor_By_Documento]
@IdEmpresa INT,
@IdTipoDocumento INT,
@NumeroDocumento VARCHAR(20)
AS
BEGIN
	SELECT		
			C.ID,
			P.Nombre,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
			E.Direccion AS "Direccion",
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			EN.Nombre AS "NombreCompleto"
	FROM ERP.Proveedor C
	INNER JOIN ERP.Entidad EN
		ON EN.ID = C.IdEntidad
	INNER JOIN ERP.Establecimiento E
		ON E.IdEntidad = EN.ID
	LEFT JOIN ERP.Persona P
		ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
WHERE ETD.IdTipoDocumento = @IdTipoDocumento AND ETD.NumeroDocumento = @NumeroDocumento AND IdEmpresa = @IdEmpresa AND C.Flag = 1 AND C.FlagBorrador = 0
END

