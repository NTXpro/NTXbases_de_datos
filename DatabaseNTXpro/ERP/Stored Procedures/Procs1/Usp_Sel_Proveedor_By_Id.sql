CREATE PROC [ERP].[Usp_Sel_Proveedor_By_Id] 
@Id INT
AS
BEGIN
	
	SELECT P.ID,
		   P.UsuarioActivo,
		   P.UsuarioElimino,
		   P.UsuarioModifico,
		   EN.UsuarioRegistro,
		   P.FechaActivacion,
		   P.FechaEliminado,
		   P.FechaModificado,
		   EN.FechaRegistro,
		   P.IdEntidad,
		   ETD.IdTipoDocumento,
		   ETD.NumeroDocumento,
		   EN.Nombre NombreProveedor,
		   E.Direccion + ISNULL((' - ' + U.Nombre + ' - ' + (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + ' - ' + (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))),'') Direccion,
		   P.IdTipoRelacion,
		   P.DiasVencimiento,
		   P.Correo
	FROM ERP.Proveedor P
	LEFT JOIN ERP.Entidad EN
		ON EN.ID = P.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	LEFT JOIN ERP.Establecimiento E
		ON E.IdEntidad = EN.ID
	LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = E.IdUbigeo
	WHERE P.ID = @Id
END