CREATE PROCEDURE [ERP].[Usp_Sel_Trabajador_Restaurar]
@IdEmpresa INT
AS
BEGIN
	SELECT
		T.ID,
		TP.ID AS IdTipoPersona,
		TP.Nombre AS NombreTipoPersona,
		E.Nombre AS NombreEntidad,
		TD.ID AS IdTipoDocumento,
		TD.Abreviatura NombreTipoDocumento,
		ETD.NumeroDocumento,
		P.FechaNacimiento,
		EC.ID AS IdEstadoCivil,
		EC.Nombre AS NombreEstadoCivil,
		S.ID AS IdSexo,
		S.Nombre AS NombreSexo
	FROM ERP.Trabajador T
	INNER JOIN ERP.Entidad E ON E.ID = T.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD ON E.ID = ETD.IdEntidad
	INNER JOIN PLE.T2TipoDocumento TD ON ETD.IdTipoDocumento = TD.ID
	INNER JOIN Maestro.TipoPersona TP ON E.IdTipoPersona = TP.ID
	LEFT JOIN ERP.Persona P ON E.ID = P.IdEntidad
	LEFT JOIN Maestro.EstadoCivil EC ON P.IdEstadoCivil = EC.ID
	LEFT JOIN Maestro.Sexo S ON P.IdSexo = S.ID
	INNER JOIN ERP.Establecimiento ES ON E.ID = ES.IdEntidad AND ES.IdTipoEstablecimiento = 1
	LEFT JOIN [PLAME].[T7Ubigeo] U1 ON ES.IdUbigeo = U1.ID
	LEFT JOIN [PLAME].[T7Ubigeo] U2 ON CONCAT('00', SUBSTRING(U1.CodigoSunat, 1,4)) = U2.CodigoSunat
	LEFT JOIN [PLAME].[T7Ubigeo] U3 ON CONCAT('0000', SUBSTRING(U1.CodigoSunat, 1,2)) = U3.CodigoSunat
	WHERE 
	T.Flag = 0 AND
	T.IdEmpresa = @IdEmpresa
END
