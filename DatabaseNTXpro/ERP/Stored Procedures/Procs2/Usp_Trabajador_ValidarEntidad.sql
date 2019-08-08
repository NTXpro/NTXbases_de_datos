CREATE PROC [ERP].[Usp_Trabajador_ValidarEntidad] --'47340439'
@NumeroDocumento VARCHAR(50)
AS
BEGIN
	SELECT
		T.ID AS IdTrabajador,
		E.ID AS IdEntidad, 
		P.Nombre,
		P.ApellidoPaterno,
		P.ApellidoMaterno,
		P.IdEstadoCivil,
		P.FechaNacimiento,
		P.IdNivelEducativo,
		P.IdCentroAsistencial,
		P.IdSexo,
		ES.ID AS IdEstablecimientoPrincipal,
		ES.IdVia,
		ES.ViaNombre,
		ES.ViaNumero,
		Es.Interior,
		Es.Sector,
		ES.Grupo,
		ES.Manzana,
		ES.Lote,
		ES.Kilometro,
		ES.IdZona,
		ES.ZonaNombre,
		ES.Referencia,
		ES.Direccion,
		ES.IdUbigeo,
		U2.ID AS IdProvincia,
		U3.ID AS IdDepartamento
	FROM [ERP].[Entidad] E
	LEFT JOIN ERP.Trabajador T ON E.ID = T.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD ON E.ID = ETD.IdEntidad
	INNER JOIN ERP.Persona P ON E.ID = P.IdEntidad
	INNER JOIN ERP.Establecimiento ES ON E.ID = ES.IdEntidad
	LEFT JOIN [PLAME].[T7Ubigeo] U1 ON ES.IdUbigeo = U1.ID
	LEFT JOIN [PLAME].[T7Ubigeo] U2 ON CONCAT('00', SUBSTRING(U1.CodigoSunat, 1,4)) = U2.CodigoSunat
	LEFT JOIN [PLAME].[T7Ubigeo] U3 ON CONCAT('0000', SUBSTRING(U1.CodigoSunat, 1,2)) = U3.CodigoSunat
	WHERE ETD.NumeroDocumento = @NumeroDocumento AND ES.IdTipoEstablecimiento = 1;
END
