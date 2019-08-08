create PROC [ERP].[Usp_ClienteByNombre]-- 3697 22
@Nombre varchar(250),
@Centro varchar(250)
AS
BEGIN

	SELECT	C.ID,
			C.UsuarioActivo,
			C.UsuarioElimino,
			C.UsuarioModifico,
			C.UsuarioRegistro,
			c.FechaActivacion,
			c.FechaEliminado,
			C.FechaModificado,
			EC.FechaRegistro,
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			EC.Nombre NombreCliente,
			E.Direccion + ISNULL((' - ' + U.Nombre + ' - ' + (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + ' - ' + (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))),'') Direccion,
			C.IdEntidad,
			C.IdVendedor,
			ENT.Nombre NombreVendedor,
			C.IdTipoRelacion,
			C.Correo,
			C.FlagClienteBoleta,
			C.DiasVencimiento,
			ES.ID IdEstablecimientoCliente
	FROM ERP.Cliente C
	LEFT JOIN ERP.Entidad EC
		ON EC.ID = C.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EC.ID
	LEFT JOIN (SELECT IdEntidad, IdUbigeo, Direccion FROM ERP.Establecimiento WHERE IdTipoEstablecimiento = 1) E
		ON E.IdEntidad = EC.ID
	LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = E.IdUbigeo
	LEFT JOIN ERP.Vendedor V
		ON V.ID = C.IdVendedor
	LEFT JOIN ERP.Trabajador T
		ON T.ID = V.IdTrabajador
	LEFT JOIN ERP.Entidad ENT
		ON ENT.ID = T.IdEntidad
	LEFT JOIN ERP.Establecimiento ES ON C.IdEntidad= ES.IdEntidad 

	WHERE EC.Nombre=@Nombre and ES.Nombre like '%' + @Centro + '%'
END